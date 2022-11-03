//
//  AuthService.swift
//  Fake Store
//
//  Created by Антон Голубейков on 13.10.2022.
//

import Foundation

struct AuthService {

    let dataTask = BaseNetworkTask<AuthRequestModel, AuthResponseModel>(
        method: .post,
        path: "auth/login"
    )

    func performLoginRequestAndSaveToken(
        credentials: AuthRequestModel,
        _ onResponseWasReceived: @escaping (_ result: Result<AuthResponseModel, Error>) -> Void
    ) {
        dataTask.performRequest(input: credentials) { result in
            if case let .success(responseModel) = result {
                do {
                    try dataTask.tokenStorage.set(newToken: TokenContainer(token: responseModel.token, receivingDate: .now))
                    onResponseWasReceived(result)
                } catch {
                    onResponseWasReceived(result)
                }
            } else {
                onResponseWasReceived(result)
            }
        }
    }
}
