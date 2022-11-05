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

    private var productsInCart: [ProductModel] = []
    private let favoritesStorage = FavoritesStorage.shared

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
                        let productCount = UserDefaults.standard.integer(forKey: "\(product.id)")
                        self.editProductsInCart(product: &product, newQuantity: productCount)
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

    func getProductsInCart() -> [ProductModel] {
        return productsInCart
    }

    func editProductsInCart(product: inout ProductModel, newQuantity: Int) {
        product.count = newQuantity
        guard product.count != 0 else {
            guard let indexToRemove = productsInCart.firstIndex(where: { $0.id == product.id }) else { return }
            productsInCart.remove(at: indexToRemove)
            UserDefaults.standard.removeObject(forKey: "\(product.id)")
            return
        }
        if !isProductInCart(product) || !productsInCart.contains(where: { $0.id == product.id }) {
            productsInCart.append(product)
        } else {
            guard let indexOfProduct = productsInCart.firstIndex(where: { $0.id == product.id }) else { return }
            productsInCart[indexOfProduct].count = newQuantity
        }
        UserDefaults.standard.set(product.count, forKey: "\(product.id)")
    }

}

// MARK: - Private extension

private extension CartService {

    func isProductInCart(_ product: ProductModel) -> Bool {
        UserDefaults.standard.value(forKey: "\(product.id)") != nil ? true : false
    }

}


