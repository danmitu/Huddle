//
//  NetworkManager.swift
//  Huddle
//
//  Created by Dan Mitu on 1/21/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//
//  Source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    
    // MARK: - Properties
    
    static let environment : NetworkEnvironment = .production
    
    let router = Router<HuddleApi>()
    
    // MARK: - Methods
    
    func readProfile(completion: @escaping (_ member: Member?, _ error: String?)->()) {
        router.request(.readMember) { data, response, error in
            guard error == nil else {
                completion(nil, "Please check your network connection.")
                return
            }
            guard let jsonData = data else {
                completion(nil, NetworkResponse.noData.rawValue)
                return
            }
            
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                let member = try! JSONDecoder().decode(Member.self, from: jsonData)
                completion(member, nil)
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
            
        }
    }
    
    func isLoggedIn(completion: @escaping (_ result: Bool?)->()) {
        router.request(.readMember) { _, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            let response = response as! HTTPURLResponse
            switch response.statusCode {
            case 200...299: completion(true)
            case 401...500: completion(false)
            default: completion(nil)
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (_ error: String?)->()) {
        router.request(.login(email: email, password: password)) { data, response, error in
            guard error == nil else {
                completion("Please check your network connection.")
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                completion(nil)
            case .failure(let networkFailureError):
                completion(networkFailureError)
            }
        }
    }
    
    func create(email: String, password: String, fullName: String,  completion: @escaping (_ error: String?)->()) {
        router.request(.create(email: email, password: password, fullName: fullName)) { data, response, error in
            guard error == nil else {
                completion("Please check your network connection.")
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                completion(nil)
            case .failure(let networkFailureError):
                completion(networkFailureError)
            }
        }
    }
    
    func updatePassword(oldPassword: String, newPassword: String, completion: @escaping (_ error: String?)->()) {
        router.request(.updatePassword(oldPassword: oldPassword, newPassword: newPassword)) { data, response, error in
            guard error == nil else {
                completion("Please check your network connection.")
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                completion(nil)
            case .failure(let networkFailureError):
                completion(networkFailureError)
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
