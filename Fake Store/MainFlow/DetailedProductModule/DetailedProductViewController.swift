//
//  DetailedProductViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 29.10.2022.
//

import UIKit

final class DetailedProductViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var goodsInCartLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var goToCartButtonLabel: UIButton!

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

    // MARK: - Init

    init(model: ProductModel) {
        self.model = model
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

}

// MARK: - Private methods

private extension DetailedProductViewController {

    func configureAppearance() {
        configureBackgroundStyle()
        configureProductImageView()
        configureProductNameLabel()
        configureProductPriceLabel()
        configureLoginButton()
    }

    func configureNavigationView() {
        navigationItem.title = "Карточка товара"
    }

    func configureBackgroundStyle() {
        backgroundView.backgroundColor = ColorsStorage.white
        setGradientBackground()
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
