//
//  FavoritesViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 05.11.2022.
//

import UIKit

final class FavoritesViewController: BaseUIViewController {

    // MARK: - Constants

    private enum ConstantConstraints {
        static let collectionViewPadding: CGFloat = 16
        static let hSpaceBetweenItems: CGFloat = 7
        static let vSpaceBetweenItems: CGFloat = 8
    }
    private let cellProportion: Double = 333/196
    private let allProductsCollectionViewCell: String = "\(ProductCollectionViewCell.self)"
    private let navigationTitle = "Избранное"
    private let alertViewText: String = "Вы точно хотите удалить из избранного?"

    // MARK: - IBOutletls

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyFavoritesNotificationText: UILabel!

    // MARK: - Properties

    static var favoriteTapStatus: Bool = false
    static var successLoadingPostsAfterZeroScreen: Bool = false

    // MARK: - Views

    private let refreshControl = UIRefreshControl()

    // MARK: - Private properties

    private let productsModel = AllProductsModel.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        productsModel.loadProducts()
        configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBarStyle()
        if !(productsModel.favoriteItems.isEmpty) {
            nonEmptyFavoritesNotification()
            favoritesCollectionView.reloadData()
            FavoritesViewController.successLoadingPostsAfterZeroScreen = false
        }
        if FavoritesViewController.favoriteTapStatus {
            favoritesCollectionView.reloadData()
            FavoritesViewController.favoriteTapStatus = false
            productsModel.favoriteItems.isEmpty ? emptyFavoritesNotification() : nonEmptyFavoritesNotification()
        }
    }

}

// MARK: - Private methods

private extension FavoritesViewController {

    func configureAppearance() {
        configureModel()
        configureCollectionView()
        configurePullToRefresh()
        nonEmptyFavoritesNotification()
        setGradientBackground()
    }

    func configureNavigationBarStyle() {
        configureNavigationBar(title: navigationTitle, backgroundColor: ColorsStorage.backgroundBlue, titleColor: ColorsStorage.black, isStatusBarDark: false)
        let baseNavigationController = navigationController as? BaseUINavigationController
        baseNavigationController?.setStatusBar(backgroundColor: ColorsStorage.backgroundBlue)
    }

    func configureCollectionView() {
        favoritesCollectionView.register(UINib(nibName: allProductsCollectionViewCell, bundle: .main), forCellWithReuseIdentifier: allProductsCollectionViewCell)
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        favoritesCollectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
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
                if !(self.productsModel.favoriteItems.isEmpty) {
                    self.nonEmptyFavoritesNotification()
                } else {
                    self.emptyFavoritesNotification()
                }
                self.favoritesCollectionView.reloadData()
             }
        }
    }

    func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = ColorsStorage.lightGray
        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        favoritesCollectionView.addSubview(refreshControl)
    }

    @objc func pullToRefresh(_ sender: AnyObject) {
         self.productsModel.loadProducts()
         refreshControl.endRefreshing()
    }

    func setGradientBackground() {
        favoritesCollectionView.backgroundColor = ColorsStorage.clear
        let colorTop = ColorsStorage.white.cgColor
        let colorBottom = ColorsStorage.gradientBlue.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

    }

    func emptyFavoritesNotification() {
        refreshControl.isHidden = true
        emptyFavoritesNotificationText.font = .systemFont(ofSize: 14, weight: .light)
        emptyFavoritesNotificationText.text = "В избранном пусто"
    }
    func nonEmptyFavoritesNotification() {
        configurePullToRefresh()
        emptyFavoritesNotificationText.text = ""
    }

}

// MARK: - CollectionView

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsModel.favoriteItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: allProductsCollectionViewCell, for: indexPath)
        if let cell = cell as? ProductCollectionViewCell {
            activityIndicator.isHidden = true
            cell.configureCell(for: productsModel.favoriteItems[indexPath.row])
            cell.isFavorite = productsModel.favoriteItems[indexPath.row].isFavorite
            cell.didFavoritesTap = { [weak self] in
                self?.favoritesCollectionView.reloadData()
            }
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
        let detailedProductViewController = DetailedProductViewController(model: productsModel.favoriteItems[indexPath.row], isFavorite: productsModel.favoriteItems[indexPath.row].isFavorite)
        navigationController?.pushViewController(detailedProductViewController, animated: true)
    }

}

