//
//  AppAPI.swift
//  AppAPI
//
//  Created by jerome on 31/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import PromiseKit


// MARK: - AppAPI
// -
struct AppAPI {
    private let api = DailySpecialApi.shared
    static let shared: AppAPI = AppAPI()
    private init() {}
    
    enum ApiError: Error {
        case noEmail
        case refreshTokenFailed
    }
    
    private func register() -> Promise<RegisterResponse> {
        guard let route = RegisterRoute(email: SessionController().email) else {
            return Promise<RegisterResponse>.init(error: ApiError.noEmail)
        }
        return api.perform(route).get { response in
            var session = SessionController()
            session.token = response.token
            session.refreshToken = response.refreshToken
        }
    }
    
    func retrieveToken()  -> Promise<RegisterResponse> {
        return register().get { response in
            var session = SessionController()
            session.token = response.token
            session.refreshToken = response.refreshToken
        }
    }
}

//MARK:- Internal class for API
private class DailySpecialApi: API {
    // Singleton
    static let shared: DailySpecialApi = DailySpecialApi()
    
    /// URL de base de l'api Transport.
    var baseURL: URL {
        URL(string: "http://www.apiportail.kaiman.fr/public/api/")!
    }
    
    /// Headers communs à tous les appels (aucun pour cette api)/
    var commonHeaders: HTTPHeaders? {
        var header = HTTPHeaders.init([HTTPHeader.contentType("application/json")])
        if let token = SessionController().token {
            header.add(HTTPHeader.authorization(bearerToken: token))
        }
        return header
    }
    
    var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
}

//MARK:- Common parameters Encodable base class
// make all routes pamraetrs inherit from this class to allow common parameters...
class CovidAppApiCommonParameters: RequestParameters {
}


//MARK:- Covid Private extension
private extension AppAPI {
    func perform<T>(route: RequestObject<T>, showMessageOnFail: Bool = true) -> Promise<T> {
        return Promise<T>.init { resolver in
            performAndRetry(route: route)
                .done { object in
                    resolver.fulfill(object)
            }
            .catch { error in
                if showMessageOnFail {
//                    MessageManager.show(.request(.serverError))
                }
                resolver.reject(error)
            }
        }
    }
    
    func performAndRetry<T>(route: RequestObject<T>) -> Promise<T> {
        func refresh() -> Promise<T> {
            register()
                .then { response -> Promise<T> in
                    self.performAndRetry(route: route)
            }
        }
        
        var hasRefreshed: Bool = false
        return
            api
            .perform(route)
            .recover { error -> Promise<T> in
                switch error {
                case AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401)) where hasRefreshed == false:
                    // only once
                    hasRefreshed = true
                    print("🐞 refresh token try....")
                    return refresh()
                    
                default: return Promise<T>.init(error: error)
                }
    
        }
    }
}
