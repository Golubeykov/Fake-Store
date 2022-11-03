//
//  BaseNetworkTask.swift
//  Fake Store
//
//  Created by Антон Голубейков on 13.10.2022.
//

import Foundation

struct BaseNetworkTask<AbstractInput: Encodable, AbstractOutput: Decodable>: NetworkTask {

    // MARK: - NetworkTask

    typealias Input = AbstractInput
    typealias Output = AbstractOutput

    var baseURL: URL? {
        URL(string: "https://fakestoreapi.com")
    }

    let path: String
    let method: NetworkMethod
    let session: URLSession = URLSession(configuration: .default)
    var tokenStorage: TokenStorage {
        BaseTokenStorage()
    }

    // MARK: - Initializtion

    init(method: NetworkMethod, path: String) {
        self.path = path
        self.method = method
    }

    // MARK: - NetworkTask

    func performRequest(
        input: AbstractInput,
        _ onResponseWasReceived: @escaping (_ result: Result<AbstractOutput, Error>) -> Void
    ) {
        do {
            let request = try getRequest(with: input)

            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    if error.localizedDescription == LocalizedDescriptions.noNetworkSimulator || error.localizedDescription == LocalizedDescriptions.noNetworkDevice {
                        onResponseWasReceived(.failure(PossibleErrors.noNetworkConnection))
                    } else {
                    onResponseWasReceived(.failure(PossibleErrors.unknownError))
                    }

                } else if let data = data {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            do {
                                let mappedModel = try JSONDecoder().decode(AbstractOutput.self, from: data)
                                onResponseWasReceived(.success(mappedModel))
                            } catch {
                                onResponseWasReceived(.failure(PossibleErrors.unknownError))
                            }
                        case 401:
                            onResponseWasReceived(.failure(PossibleErrors.nonAuthorizedAccess))
                        default:
                            onResponseWasReceived(.failure(PossibleErrors.unknownServerError))
                        }
                    }

                } else {
                    onResponseWasReceived(.failure(PossibleErrors.unknownError))
                }
            }
            .resume()
        } catch {
            onResponseWasReceived(.failure(PossibleErrors.unknownError))
        }
    }

}


// MARK: - EmptyModel
extension BaseNetworkTask where Input == EmptyModel {

    func performRequest(_ onResponseWasReceived: @escaping (_ result: Result<AbstractOutput, Error>) -> Void) {
        performRequest(input: EmptyModel(), onResponseWasReceived)
    }

}

// MARK: - Private Methods
private extension BaseNetworkTask {

    func getRequest(with parameters: AbstractInput) throws -> URLRequest {
        guard let url = completedURL else {
            throw PossibleErrors.urlWasNotFound
        }

        var request: URLRequest
        switch method {
        case .get:
            let newUrl = try getUrlWithQueryParameters(for: url, parameters: parameters)
            request = URLRequest(url: newUrl)
        case .post:
            request = URLRequest(url: url)
            request.httpBody = try getParametersForBody(from: parameters)
        }
        request.httpMethod = method.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }

    func getParametersForBody(from encodableParameters: AbstractInput) throws -> Data {
        return try JSONEncoder().encode(encodableParameters)
    }

    func getUrlWithQueryParameters(for url: URL, parameters: AbstractInput) throws -> URL {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw PossibleErrors.urlComponentWasNotCreated
        }

        let parametersInDataRepresentation = try JSONEncoder().encode(parameters)
        let parametersInDictionaryRepresentation = try JSONSerialization.jsonObject(with: parametersInDataRepresentation)

        guard let parametersInDictionaryRepresentation = parametersInDictionaryRepresentation as? [String: Any] else {
            throw PossibleErrors.parametersIsNotValidJsonObject
        }

        let queryItems = parametersInDictionaryRepresentation.map { key, value in
            return URLQueryItem(name: key, value: "\(value)")
        }

        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let newUrlWithQuery = urlComponents.url else {
            throw PossibleErrors.urlWasNotFound
        }

        return newUrlWithQuery
    }

}
