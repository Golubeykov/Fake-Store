//
//  ProductsService.swift
//  Fake Store
//
//  Created by Антон Голубейков on 23.10.2022.
//

import Foundation

struct ProductsService {

    let category: String
    var dataTask: BaseNetworkTask<EmptyModel, [ProductsResponseModel]> { BaseNetworkTask<EmptyModel, [ProductsResponseModel]> (
        method: .get,
        path: "products/category/\(category)"
    )
    }

    func loadProducts(_ onResponseWasReceived: @escaping (_ result: Result<[ProductsResponseModel], Error>) -> Void) {
        dataTask.performRequest(onResponseWasReceived)
    }

}
