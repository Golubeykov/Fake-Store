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

    var productsInCategory: [ProductModel] = []
    var allProducts: [ProductModel] = []

    let favoritesStorage = FavoritesStorage.shared
    var favoriteItems: [ProductModel] {
        allProducts.filter { $0.isFavorite }
    }

    // MARK: - Methods

    func loadProductsInCategory(_ category: String) {
        let productService = ProductsInCategoryService(category: category)
        productService.loadProducts { [weak self] result in
            switch result {
            case .success(let productsResult):
                self?.productsInCategory = productsResult.map { productModel in
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

    func loadProducts() {
        let productService = ProductsService()
        productService.loadProducts { [weak self] result in
            switch result {
            case .success(let productsResult):
                self?.allProducts = productsResult.map { productModel in
                    ProductModel(id: productModel.id,
                                 title: productModel.title,
                                 price: productModel.price,
                                 imageURL: productModel.image,
                                 category: productModel.category)
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
        productsInCategory = []
    }

}

struct ProductModel {

    let id: Int
    let title: String
    let price: Double
    let imageURL: String
    let category: String
    var count: Int = 0
    var isFavorite: Bool {
        FavoritesStorage.shared.isItemFavorite(item: self.title)
    }

}
