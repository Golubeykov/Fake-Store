//
//  ProductCollectionViewCell.swift
//  Fake Store
//
//  Created by Антон Голубейков on 23.10.2022.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    private enum Constants {
        static let favoriteTapped = UIImage(named: "favoriteIcon")?.withTintColor(ColorsStorage.darkBlue)
        static let favoriteUntapped = UIImage(named: "favoriteIcon")?.withTintColor(ColorsStorage.backgroundGray)
        static let cartTapped = UIImage(named: "cartIcon")?.withTintColor(ColorsStorage.darkBlue)
        static let cartUntapped = UIImage(named: "cartIcon")?.withTintColor(ColorsStorage.backgroundGray)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var priceTagLabel: UILabel!
    @IBOutlet private weak var nameTagLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var favoriteProductButton: UIButton!
    @IBOutlet weak var addToCartButtonLabel: UIButton!

    // MARK: - Properties

    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                 return
             }
             productImageView.loadImage(from: url)
        }
    }
    var favoriteButtonImage: UIImage? {
        return isFavorite ? Constants.favoriteTapped : Constants.favoriteUntapped
    }
    var cartButtonImage: UIImage? {
        return isProductInCart ? Constants.cartTapped : Constants.cartUntapped
    }

    var isFavorite = false {
        didSet {
            favoriteProductButton.setImage(favoriteButtonImage, for: .normal)
        }
    }
    var isProductInCart = false {
        didSet {
            addToCartButtonLabel.setImage(cartButtonImage, for: .normal)
        }
    }
    let favoritesStorage = FavoritesStorage.shared
    var didFavoritesTap: (() -> Void)?
    var didCartButtonTapped: (() -> Void)?

    // MARK: - Methods

    func configureCell(for model: ProductModel) {
        configureImage(model)
        configurePriceTagLabel(model)
        configureNameTagLabel(model)
        configureCategoryLabel(model)
        setGradientBackground()
    }

    // MARK: - Actions

    @IBAction func favoriteProductButtonAction(_ sender: Any) {
        didFavoritesTap?()
        if favoritesStorage.isItemFavorite(item: self.nameTagLabel.text ?? "") {
            favoritesStorage.removeFavorite(favoriteItem: self.nameTagLabel.text ?? "")
        } else {
            favoritesStorage.addFavorite(favoriteItem: self.nameTagLabel.text ?? "")
        }
        isFavorite.toggle()
    }

    @IBAction func addToCartButtonAction(_ sender: Any) {
        didCartButtonTapped?()
        isProductInCart.toggle()
    }
    

    // MARK: - Private methods

    private func configureImage(_ model: ProductModel) {
        imageUrlInString = model.imageURL
    }

    private func configureNameTagLabel(_ model: ProductModel) {
        nameTagLabel.text = model.title
        nameTagLabel.font = .systemFont(ofSize: 13, weight: .semibold)
    }

    private func configurePriceTagLabel(_ model: ProductModel) {
        priceTagLabel.text = "\(model.price) $"
        priceTagLabel.font = .systemFont(ofSize: 15, weight: .bold)
    }

    private func configureCategoryLabel(_ model: ProductModel) {
        categoryLabel.text = model.category
        categoryLabel.font = .systemFont(ofSize: 13, weight: .regular)
    }

    private func setGradientBackground() {
        let colorTop = ColorsStorage.white.cgColor
        let colorBottom = ColorsStorage.orange.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundView = backgroundView

    }

    // MARK: - Reuse

    override func prepareForReuse() {
        productImageView.image = UIImage()
        priceTagLabel.text = ""
        categoryLabel.text = ""
        nameTagLabel.text = ""
    }

}
