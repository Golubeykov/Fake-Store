//
//  CatalogModule.swift
//  Fake Store
//
//  Created by Антон Голубейков on 22.10.2022.
//

import Foundation

final class AllCatalogModel {

    static let shared = AllCatalogModel.init()
    static var errorDescription: String = "Что-то пошло не так"

    var didCatalogUpdated: (()->Void)?
    var didCatalogFetchErrorHappened: (()->Void)?

    let catalogService = CatalogService()
    var catalog: [CatalogModel] = []

    func loadCatalog() {
        catalogService.requestCategoriesList { [weak self] result in
            switch result {
            case .success(let catalogResult):
                self?.catalog = catalogResult.map { catalogModel in
                    CatalogModel(title: catalogModel)
                }
                self?.didCatalogUpdated?()
            case .failure(let error):
                if let networkError = error as? PossibleErrors {
                    switch networkError {
                    case .noNetworkConnection:
                        AllCatalogModel.errorDescription = "Отсутствует интернет соединение"
                    default:
                        AllCatalogModel.errorDescription = "Что-то пошло не так"
                    }
                }
                self?.didCatalogFetchErrorHappened?()
            }
        }
    }

}

struct CatalogModel {

    let title: String

}
