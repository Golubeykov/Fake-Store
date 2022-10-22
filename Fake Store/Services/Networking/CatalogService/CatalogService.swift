//
//  CatalogService.swift
//  Fake Store
//
//  Created by Антон Голубейков on 22.10.2022.
//

import Foundation

struct CatalogService {

    let dataTask = BaseNetworkTask<EmptyModel, [String]>(
        method: .get,
        path: "products/categories"
    )

    func requestCategoriesList(_ onResponseWasRecieved: @escaping (_ result: Result<[String], Error>) -> Void) {
        dataTask.performRequest(onResponseWasRecieved)
    }

}
