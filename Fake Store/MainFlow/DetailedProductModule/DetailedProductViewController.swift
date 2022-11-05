//
//  DetailedProductViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 29.10.2022.
//

import UIKit

final class DetailedProductViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let favoriteTapped = UIImage(named: "favoriteIcon")?.withTintColor(ColorsStorage.darkBlue)
        static let favoriteUntapped = UIImage(named: "favoriteIcon")?.withTintColor(ColorsStorage.backgroundGray)
    }

    // MARK: - IBOutlets

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var goodsInCartLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var goToCartButtonLabel: UIButton!
    @IBOutlet weak var favoriteProductButton: UIButton!

    // MARK: - Properties

    var model: ProductModel
    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                 return
             }
             productImageView.loadImage(from: url)
        }
    }
    var buttonImage: UIImage? {
        return isFavorite ? Constants.favoriteTapped : Constants.favoriteUntapped
    }
    var isFavorite: Bool {
        didSet {
            favoriteProductButton.setImage(buttonImage, for: .normal)
        }
    }
    let favoritesStorage = FavoritesStorage.shared
    var didFavoritesTap: (() -> Void)?

    // MARK: - Init

    init(model: ProductModel, isFavorite: Bool) {
        self.model = model
        self.isFavorite = isFavorite
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goodsInCartLabel.text = "Количество товара: \(UserDefaults.standard.integer(forKey: "\(model.id)"))"
        stepper.value = Double(UserDefaults.standard.integer(forKey: "\(model.id)"))
        model.count = UserDefaults.standard.integer(forKey: "\(model.id)")
        configureNavigationView()
    }

    // MARK: - Actions

    @IBAction func stepperAction(_ sender: UIStepper) {
        goodsInCartLabel.text = "Количество товара: \(Int(sender.value))"
        model.count = Int(sender.value)
    }
    @IBAction func goToCartButtonAction(_ sender: Any) {
        CartService.shared.editProductsInCart(product: &model, newQuantity: model.count)
        tabBarController?.selectedIndex = 2
    }
    @IBAction func favoriteProductButtonAction(_ sender: Any) {
        didFavoritesTap?()
        if favoritesStorage.isItemFavorite(item: self.productNameLabel.text ?? "") {
            favoritesStorage.removeFavorite(favoriteItem: self.productNameLabel.text ?? "")
        } else {
            favoritesStorage.addFavorite(favoriteItem: self.productNameLabel.text ?? "")
        }
        isFavorite.toggle()
    }

}

// MARK: - Private methods

private extension DetailedProductViewController {

    func configureAppearance() {
        configureBackgroundStyle()
        configureProductImageView()
        configureProductNameLabel()
        configureProductPriceLabel()
        configureLoginButton()
        configureFavoriteButton()
    }

    func configureNavigationView() {
        navigationItem.title = "Карточка товара"
    }

    func configureBackgroundStyle() {
        backgroundView.backgroundColor = ColorsStorage.white
        setGradientBackground()
    }

    func configureFavoriteButton() {
        favoriteProductButton.setImage(buttonImage, for: .normal)
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

    func configureProductImageView() {
        imageUrlInString = model.imageURL
    }

    func configureProductNameLabel() {
        productNameLabel.text = model.title
        productNameLabel.font = .systemFont(ofSize: 17, weight: .regular)
    }

    func configureProductPriceLabel() {
        productPriceLabel.text = "\(model.price) $"
        productPriceLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }

    func configureLoginButton() {
        goToCartButtonLabel.backgroundColor = ColorsStorage.orange
        goToCartButtonLabel.setTitle("Добавить в корзину", for: .normal)
        goToCartButtonLabel.tintColor = ColorsStorage.black
    }

}
