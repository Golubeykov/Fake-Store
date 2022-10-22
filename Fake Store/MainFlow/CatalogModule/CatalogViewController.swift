//
//  CatalogViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 22.10.2022.
//

import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var catalogTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: - Views

    private let refreshControl = UIRefreshControl()

    // MARK: - Private properties

    private let catalogModel = AllCatalogModel.shared
    private let cellReuseIndentifier = "CatalogCell"
    private let navigationBarTitle = "Каталог"
    private let searchBarPlaceholder = "Поиск"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        catalogModel.loadCatalog()
        configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        setGradientBackground()
    }

}

// MARK: - Private methods

private extension CatalogViewController {

    func configureAppearance() {
        configureTableView()
        configureModel()
        configurePullToRefresh()
        configureSearchBar()
        configureViewStyle()
    }

    func configureTableView() {
        catalogTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIndentifier)
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
    }

    func configureNavigationBar() {
        navigationItem.title = navigationBarTitle
    }

    func configureViewStyle() {
        view.backgroundColor = ColorsStorage.backgroundBlue
    }

    func setGradientBackground() {
        let colorTop = ColorsStorage.white.cgColor
        let colorBottom = ColorsStorage.gradientBlue.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.catalogTableView.bounds
        let backgroundView = UIView(frame: catalogTableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.catalogTableView.backgroundView = backgroundView

    }

    func configureModel() {
        catalogModel.didCatalogFetchErrorHappened = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.activityIndicator.isHidden = true
                let textForSnackBar = AllCatalogModel.errorDescription
                let model = SnackbarModel(text: textForSnackBar)
                let snackbar = SnackbarView(model: model, viewController: self)
                snackbar.showSnackBar()
            }
        }
        catalogModel.didCatalogUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.activityIndicator.isHidden = true
                self.catalogTableView.reloadData()
             }
        }
    }

    func configureSearchBar() {
        searchBar.placeholder = searchBarPlaceholder
        searchBar.barTintColor = ColorsStorage.backgroundBlue
    }

    func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = ColorsStorage.lightGray
        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        catalogTableView.addSubview(refreshControl)
    }

    @objc func pullToRefresh(_ sender: AnyObject) {
        self.catalogModel.loadCatalog()
        refreshControl.endRefreshing()
    }

}

// MARK: - Table View

extension CatalogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        catalogModel.catalog.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catalogTableView.dequeueReusableCell(withIdentifier: cellReuseIndentifier, for: indexPath)
        cell.textLabel?.text = catalogModel.catalog[indexPath.row].title
        return cell
    }

}
