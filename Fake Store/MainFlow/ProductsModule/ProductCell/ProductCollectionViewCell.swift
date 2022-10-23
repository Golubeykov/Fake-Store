//
//  ProductCollectionViewCell.swift
//  Fake Store
//
//  Created by Антон Голубейков on 23.10.2022.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var priceTagLabel: UILabel!
    @IBOutlet private weak var nameTagLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!

    // MARK: - Methods

    func configureCell() {
        configurePriceTagLabel()
        configureNameTagLabel()
        configureCategoryLabel()
    }

    // MARK: - Private methods

    func configurePriceTagLabel() {
        priceTagLabel.font = .systemFont(ofSize: 15, weight: .bold)
    }

    func configureNameTagLabel() {
        nameTagLabel.font = .systemFont(ofSize: 13, weight: .semibold)
    }

    func configureCategoryLabel() {
        categoryLabel.font = .systemFont(ofSize: 13, weight: .regular)
    }

}
