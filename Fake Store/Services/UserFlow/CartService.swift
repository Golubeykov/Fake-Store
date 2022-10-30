//
//  CartService.swift
//  Fake Store
//
//  Created by Антон Голубейков on 30.10.2022.
//

import Foundation

final class CartService {

    // MARK: - Init

    static let shared = CartService.init()

    // MARK: - Properties

    static let errorDescription: String = "Что-то пошло не так"

    var didProductsUpdated: (() -> Void)?
    var didProductsFetchErrorHappened: (() -> Void)?

    var productsInCart: [ProductModel] = []

    func loadProducts() {
        let productService = ProductsService()
        productService.loadProducts { [weak self] result in
            switch result {
            case .success(let productsResult):
                productsResult.forEach { [weak self] productModel in
                    var product = ProductModel(id: productModel.id,
                                               title: productModel.title,
                                               price: productModel.price,
                                               imageURL: productModel.image,
                                               category: productModel.category)
                    guard let `self` = self else { return }
                    if self.isProductInCart(product) {
                        product.count = UserDefaults.standard.integer(forKey: "\(product.id)")
                        self.productsInCart.append(product)
                    }
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
        productsInCart = []
    }

    func addProductToCart(product: ProductModel) {
        guard product.count != 0 else {
            UserDefaults.standard.removeObject(forKey: "\(product.id)")
            guard let indexToRemove = productsInCart.firstIndex(where: { $0.id == product.id }) else { return }
            productsInCart.remove(at: indexToRemove)
            return
        }
        UserDefaults.standard.set(product.count, forKey: "\(product.id)")
        productsInCart.append(product)
    }

}

// MARK: - Private extension

private extension CartService {

    func isProductInCart(_ product: ProductModel) -> Bool {
        UserDefaults.standard.value(forKey: "\(product.id)") != nil ? true : false
    }

}


