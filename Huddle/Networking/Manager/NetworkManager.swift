//
//  NetworkManager.swift
//  Huddle
//
//  Created by Dan Mitu on 1/21/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//
//  Source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//

import UIKit

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
    
    // MARK: - Do Stuff Methods
    
    // MARK: Members
    
    func read(profile id: Int?, completion: @escaping (_ member: Member?, _ error: String?)->()) {
        let routeToCall: HuddleApi = id == nil ? .membersRead : .membersReadUser(id: id!)
        router.request(routeToCall) { data, response, error in
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
    
    func update(member: Member, completion: @escaping (_ error: String?)->()) {
        router.request(.membersUpdate(member: member)) { _, response, error in
            guard error == nil else {
                print(error!)
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
    
    func checkLogin(completion: @escaping (_ result: Bool?)->()) {
        router.request(.membersRead) { _, response, error in
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
        router.request(.membersLogin(email: email, password: password)) { data, response, error in
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
    
    func logout(completion: @escaping (_ error: String?)->()) {
        router.request(.membersLogout, completion: { data, response, error in
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
        })
    }
    
    func createMember(email: String, password: String, fullName: String,  completion: @escaping (_ error: String?)->()) {
        router.request(.membersCreateAccount(email: email, password: password, fullName: fullName)) { data, response, error in
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
    
    func updateMemberCredentials(oldPassword: String, newPassword: String, completion: @escaping (_ error: String?)->()) {
        router.request(.membersUpdatePassword(oldPassword: oldPassword, newPassword: newPassword)) { data, response, error in
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
    
    func get(profileImageForMember memberId: Int?, completion: @escaping (_ image: UIImage?, _ error: String?)->()) {
        let endpoint: HuddleApi
        
        switch memberId {
        case .none: endpoint = .membersProfileImage
        case .some(let memberId): endpoint = .membersNotMeProfileImage(id: memberId)
        }
        
        router.request(endpoint, completion: { data, response, error in
            guard error == nil else {
                completion(nil, "Please check your network connection.")
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                let image = UIImage(data: data!) ?? nil
                completion(image, nil)
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        })
    }
    
    func upload(memberProfileImage image: UIImage, completion: @escaping (_ error: String?)->()) {
        let media = Media(withImageAsJPEG: image)!
        router.request(.membersProfileImageUpload(media: media)) { data, response, error in
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
    
    // MARK: Groups
    
    func getGroups(forMember id: Int?, completion: @escaping (_ groups: [Group]?, _ error: String?)->()) {
        let routeToCall: HuddleApi = id == nil ? .groupsMine : .groupsOther(id: id!)
        router.request(routeToCall, completion: { data, response, error in
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
                if let groups = try? JSONDecoder().decode([Group].self, from: jsonData) {
                    completion(groups, nil)
                } else {
                    completion(nil, nil)
                }
                return
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
                return
            }
        })
    }
    
    func read(group id: Int, completion: @escaping (_ group: Group?, _ error: String?)->()) {
        
        router.request(.groupsRead(groupId: id)) { data, response, error in
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
                if let group = try? JSONDecoder().decode(Group.self, from: jsonData) {
                    completion(group, nil)
                } else {
                    completion(nil, nil)
                }
                return
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    
    func join(group id: Int, completion: @escaping (_ error: String?)->()) {
        router.request(.groupsJoin(groupId: id), completion: { data, response, error in
            guard error == nil else {
                completion("Please check your network connection.")
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                completion(nil)
                return
            case .failure(let networkFailureError):
                completion(networkFailureError)
                return
            }
        })
    }
    
    func removeSelf(fromGroup id: Int, completion: @escaping (_ error: String?)->()) {
        router.request(.groupsRemoveMe(groupId: id), completion: { data, response, error in
            guard error == nil else {
                completion("Please check your network connection.")
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                completion(nil)
                return
            case .failure(let networkFailureError):
                completion(networkFailureError)
                return
            }
        })
    }
    
    func checkSelfIsMember(withinGroup id: Int, completion: @escaping (_ value: Bool?, _ error: String?)->()) {
        router.request(.groupsIsMember(groupId: id)) { data, response, error in
            guard error == nil else {
                print(error!)
                completion(nil, "Please check your network connection.")
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                let value = String(String(bytes: data!, encoding: .utf8)!.dropLast(1)).bool!
                completion(value, nil)
                return
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
                return
            }
        }
    }
    
    // MARK: - Helpers
    
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

