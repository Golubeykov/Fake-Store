//
//  ProductsViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 23.10.2022.
//

import UIKit

class ProductsViewController: UIViewController {

    //MARK: - Constants

    private enum ConstantConstraints {
        static let collectionViewPadding: CGFloat = 16
        static let hSpaceBetweenItems: CGFloat = 7
        static let vSpaceBetweenItems: CGFloat = 8
    }
    private let cellProportion: Double = 333/196
    private let allPostsCollectionViewCell: String = "\(ProductCollectionViewCell.self)"

    // MARK: - IBOutlets

    @IBOutlet weak var productsCollectionView: UICollectionView!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
