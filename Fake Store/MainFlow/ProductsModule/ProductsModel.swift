//
//  ProductsModel.swift
//  Fake Store
//
//  Created by Антон Голубейков on 23.10.2022.
//

import UIKit

final class AllProductsModel {

    // MARK: - Init

    static let shared = AllProductsModel.init()

    // MARK: - Properties

    static let errorDescription: String = "Что-то пошло не так"

    var didProductsUpdated: (() -> Void)?
    var didProductsFetchErrorHappened: (() -> Void)?

    var products: [ProductModel] = []

    // MARK: - Methods

    func loadProductsInCategory(_ category: String) {
        let productService = ProductsInCategoryService(category: category)
        productService.loadProducts { [weak self] result in
            switch result {
            case .success(let productsResult):
                self?.products = productsResult.map { productModel in
                    ProductModel(id: productModel.id,
                                 title: productModel.title,
                                 price: productModel.price,
                                 imageURL: productModel.image,
                                 category: category)
                }
                self?.didProductsUpdated?()
            case .failure(let error):
                if let networkError = error as? PossibleErrors {
                    switch networkError {
                    case .noNetworkConnection:
                        AllCatalogModel.errorDescription = "Отсутствует интернет соединение"
                    default:
                        AllCatalogModel.errorDescription = "Что-то пошло не так"
                    }
                }
                self?.didProductsFetchErrorHappened?()
            }
        }
    }

    func removeAllProducts() {
        products = []
    }

}

struct ProductModel {

    let id: Int
    let title: String
    let price: Double
    let imageURL: String
    let category: String
    var count: Int = 0

}
