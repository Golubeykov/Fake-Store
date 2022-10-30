//
//  ProductsResponseModel.swift
//  Fake Store
//
//  Created by Антон Голубейков on 23.10.2022.
//

import Foundation

struct ProductsResponseModel: Decodable {

    let id: Int
    let title: String
    let price: Double
    let image: String
    let category: String

}
