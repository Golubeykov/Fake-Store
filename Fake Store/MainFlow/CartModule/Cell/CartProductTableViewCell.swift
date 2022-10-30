//
//  CartProductTableViewCell.swift
//  Fake Store
//
//  Created by Антон Голубейков on 29.10.2022.
//

import UIKit

final class CartProductTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!

    // MARK: - Properties

    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                 return
             }
             productImageView.loadImage(from: url)
        }
    }

    // MARK: - Actions

    @IBAction func stepperAction(_ sender: UIStepper) {
    }

    // MARK: - Methods

    func configureCell(model: ProductModel) {
        configureProductImageView(model: model)
        configureNameLabel(model: model)
        configurePriceLabel(model: model)
        configureQuantityLabel()
        setGradientBackground()
    }

    // MARK: - Private methods

    private func configureProductImageView(model: ProductModel) {
        imageUrlInString = model.imageURL
    }

    private func configureNameLabel(model: ProductModel) {
        productNameLabel.text = model.title
        productNameLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }

    private func configurePriceLabel(model: ProductModel) {
        productPriceLabel.text = "\(model.price) $"
        productPriceLabel.font = .systemFont(ofSize: 15, weight: .bold)
    }

    private func configureQuantityLabel() {
        productQuantityLabel.text = "Количество в корзине: 1"
        productQuantityLabel.font = .systemFont(ofSize: 15, weight: .regular)
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

}
