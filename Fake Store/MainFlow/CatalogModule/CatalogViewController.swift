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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        catalogModel.loadCatalog()
        configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

}

// MARK: - Private methods

private extension CatalogViewController {

    func configureAppearance() {
        configureTableView()
        configureModel()
        configurePullToRefresh()
    }

    func configureTableView() {
        catalogTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIndentifier)
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
    }

    func configureNavigationBar() {
        navigationItem.title = navigationBarTitle
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
