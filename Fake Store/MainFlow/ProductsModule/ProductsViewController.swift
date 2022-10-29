//
//  ProductsViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 23.10.2022.
//

import UIKit

final class ProductsViewController: BaseUIViewController {

    //MARK: - Constants

    private enum ConstantConstraints {
        static let collectionViewPadding: CGFloat = 16
        static let hSpaceBetweenItems: CGFloat = 7
        static let vSpaceBetweenItems: CGFloat = 8
    }
    private let cellProportion: Double = 333/196
    private let allProductsCollectionViewCell: String = "\(ProductCollectionViewCell.self)"
    private let navigationTitle = "Каталог"

    // MARK: - IBOutlets

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Views

    private let refreshControl = UIRefreshControl()

    // MARK: - Private properties

    let category: String
    private let productsModel = AllProductsModel.shared

    // MARK: - Init

    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        productsModel.loadProducts(for: category)
        configureAppearance()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBarStyle()
        setGradientBackground()
    }

    deinit {
        productsModel.removeAllPosts()
    }

}

// MARK: - Private methods

private extension ProductsViewController {

    func configureAppearance() {
        configureModel()
        configureCollectionView()
        configurePullToRefresh()
    }

    func configureNavigationBarStyle() {
        configureNavigationBar(title: navigationTitle, backgroundColor: ColorsStorage.backgroundBlue, titleColor: ColorsStorage.black, isStatusBarDark: false)
        let baseNavigationController = navigationController as? BaseUINavigationController
        baseNavigationController?.setStatusBar(backgroundColor: ColorsStorage.backgroundBlue)
    }

    func configureCollectionView() {
        productsCollectionView.register(UINib(nibName: allProductsCollectionViewCell, bundle: .main), forCellWithReuseIdentifier: allProductsCollectionViewCell)
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        productsCollectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }

    func configureModel() {
        productsModel.didProductsFetchErrorHappened = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.activityIndicator.isHidden = true
                let textForSnackBar = AllCatalogModel.errorDescription
                let model = SnackbarModel(text: textForSnackBar)
                let snackbar = SnackbarView(model: model, viewController: self)
                snackbar.showSnackBar()
            }
        }
        productsModel.didProductsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.activityIndicator.isHidden = true
                self.productsCollectionView.reloadData()
             }
        }
    }

    func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = ColorsStorage.lightGray
        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        productsCollectionView.addSubview(refreshControl)
    }

    @objc func pullToRefresh(_ sender: AnyObject) {
         self.productsModel.loadProducts(for: category)
         refreshControl.endRefreshing()
    }

    func setGradientBackground() {
        let colorTop = ColorsStorage.white.cgColor
        let colorBottom = ColorsStorage.gradientBlue.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}

// MARK: - CollectionView

extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsModel.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: allProductsCollectionViewCell, for: indexPath)
        if let cell = cell as? ProductCollectionViewCell {
            activityIndicator.isHidden = true
            cell.configureCell(for: productsModel.products[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (view.frame.width - ConstantConstraints.collectionViewPadding * 2 - ConstantConstraints.hSpaceBetweenItems) / 2
        return CGSize(width: itemWidth, height: itemWidth * cellProportion)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantConstraints.vSpaceBetweenItems
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantConstraints.hSpaceBetweenItems
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedProductViewController = DetailedProductViewController(model: productsModel.products[indexPath.row])
        navigationController?.pushViewController(detailedProductViewController, animated: true)
    }

}
