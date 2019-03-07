//
//  NetworkManager.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//
//  Source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//

import UIKit

enum NetworkResponse:String {
    case success
    case networkError = "Please check your network connection."
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
    
    /// Send a request that might receive an error.
    private func request(_ endpoint: HuddleApi, _ completion: @escaping (_ error: String?)->()) {
        router.request(endpoint) { _, response, error in
            guard error == nil else {
                completion(NetworkResponse.networkError.rawValue)
                print(error!)
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success: completion(nil)
            case .failure(let errorStr): completion(errorStr)
            }
        }
    }
    
    /// Send a request that might receive an error and gets some data.
    private func request<T:Decodable>(_ endpoint: HuddleApi, _ completion: @escaping (_ error: String?, _ item: T?)->()) {
        router.request(endpoint) { data, response, error in
            guard error == nil else {
                completion(NetworkResponse.networkError.rawValue, nil)
                print(error!)
                return
            }
            guard let data = data else {
                completion(NetworkResponse.noData.rawValue, nil)
                print(error!)
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(NetworkError.encodingFailed.rawValue, nil)
                    return
                }
                completion(nil, decodedData)
            case .failure(let errorStr):
                completion(errorStr, nil)
            }
        }
    }
    
    private func requestJson<T:Decodable>(_ endpoint: HuddleApi, _ completion: @escaping (_ error: String?, _ item: [String:T]?)->()) {
        router.request(endpoint) { data, response, error in
            guard error == nil else {
                completion(NetworkResponse.networkError.rawValue, nil)
                print(error!)
                return
            }
            guard let data = data else {
                completion(NetworkResponse.noData.rawValue, nil)
                print(NetworkResponse.noData.rawValue)
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:T] else {
                    completion(NetworkResponse.unableToDecode.rawValue, nil)
                    print(NetworkResponse.unableToDecode.rawValue)
                    return
                }
                completion(nil, dict)
            case .failure(let errorStr):
                completion(errorStr, nil)
            }
        }
    }
    
    /// Send a request that might receive an error and gets a json object (dictionary).
    private func requestJsonArray<T:Decodable>(_ endpoint: HuddleApi, _ completion: @escaping (_ error: String?, _ item: [[String:T]]?)->()) {
        router.request(endpoint) { data, response, error in
            guard error == nil else {
                completion(NetworkResponse.networkError.rawValue, nil)
                print(error!)
                return
            }
            guard let data = data else {
                completion(NetworkResponse.noData.rawValue, nil)
                print(NetworkResponse.noData.rawValue)
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:T]] else {
                    completion(NetworkResponse.unableToDecode.rawValue, nil)
                    print(NetworkResponse.unableToDecode.rawValue)
                    return
                }
                completion(nil, dict)
            case .failure(let errorStr):
                completion(errorStr, nil)
            }
        }
    }
    
    // MARK: Members
    
    func read(profile id: Int?, _ completion: @escaping ( _ error: String?, _ member: Member?)->()) {
        let endpoint: HuddleApi = id == nil ? .membersRead : .membersReadUser(id: id!)
        request(endpoint, completion)
    }
    
    func update(member: Member, completion: @escaping (_ error: String?)->()) {
        request(.membersUpdate(member: member), completion)
    }
    
    func update(group: Group, completion: @escaping (_ error: String?)->()) {
        request(.groupUpdate(group: group), completion)
    }
    
    func login(email: String, password: String, completion: @escaping (_ error: String?)->()) {
        request(.membersLogin(email: email, password: password), completion)
    }
    
    func logout(completion: @escaping (_ error: String?)->()) {
        request(.membersLogout, completion)
    }
    
    func createMember(email: String, password: String, fullName: String,  completion: @escaping (_ error: String?)->()) {
        request(.membersCreateAccount(email: email, password: password, fullName: fullName), completion)
    }
    
    func updateMemberCredentials(oldPassword: String, newPassword: String, completion: @escaping (_ error: String?)->()) {
        request(.membersUpdatePassword(oldPassword: oldPassword, newPassword: newPassword), completion)
    }
    
    func get(profileImageForMember memberId: Int?, completion: @escaping (_ error: String?, _ image: UIImage?)->()) {
        let endpoint: HuddleApi
        
        switch memberId {
        case .none: endpoint = .membersProfileImage
        case .some(let memberId): endpoint = .membersNotMeProfileImage(id: memberId)
        }
        
        router.request(endpoint, completion: { data, response, error in
            guard error == nil else {
                completion(NetworkResponse.networkError.rawValue, nil)
                print(error!)
                return
            }
            guard let data = data else {
                completion(NetworkResponse.noData.rawValue, nil)
                print(error!)
                return
            }
            let response = response as! HTTPURLResponse
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let image = UIImage(data: data) else {
                    completion(NetworkError.encodingFailed.rawValue, nil)
                    return
                }
                completion(nil, image)
            case .failure(let errorStr):
                completion(errorStr, nil)
            }
        })
    }
    
    func upload(memberProfileImage image: UIImage, completion: @escaping (_ error: String?)->()) {
        let media = Media(withImageAsJPEG: image)!
        request(.membersProfileImageUpload(media: media), completion)
    }
    
    // MARK: Events
    
    func read(event id: Int, _ completion: @escaping (_ error: String?, _ event: Event?)->()) {
        request(.eventsRead(eventId: id), completion)
    }
    
    func createEvent(groupId: Int, title: String, description: String, location: String, latitude: Double, longitude: Double, start: Date, end: Date, _ completion: @escaping (_ error: String?)->()) {
        let startString = PreferredDateFormat.describe(start, using: .format1)!
        let endString = PreferredDateFormat.describe(end, using: .format1)!
        let endpoint = HuddleApi.eventsCreate(groupId: groupId, title: title, description: description, location: location, latitude: latitude, longitude: longitude, start: startString, end: endString)
        request(endpoint, completion)
    }
    
    func update(event: Event, _ completion: @escaping (_ error: String?)->()) {
        request(.eventsUpdate(event: event), completion)
    }
    
    func delete(event id: Int, _ completion: @escaping (_ error: String?)->()) {
        request(.eventsDelete(eventId: id), completion)
    }
    
    func setRsvp(forEvent id: Int, to value: Bool, _ completion: @escaping (_ error: String?)->()) {
        request(.eventsRSVP(eventId: id, status: value), completion)
    }
    
    func getCalendar(_ completion: @escaping (_ error: String?, _ event: [Event]?)->()) {
        request(.eventsCalendar, completion)
    }
    
    func getEvents(forGroup id: Int, _ completion: @escaping (_ error: String?, _ groups: [Event]?)->()) {
        request(.eventsForGroup(groupId: id), completion)
    }
    
    
    // MARK: Groups
    
    func getGroups(forMember id: Int?, completion: @escaping (_ error: String?, _ groups: [Group]?)->()) {
        let routeToCall: HuddleApi = id == nil ? .groupsMine : .groupsOther(id: id!)
        request(routeToCall, completion)
    }
    
    func read(group id: Int, completion: @escaping (_ error: String?, _ group: Group?)->()) {
        request(.groupsRead(groupId: id), completion)
    }
    
    func createGroup(title: String, description: String, locationName: String, latitude: Double, longitude: Double, category: Category, completion: @escaping (_ error: String?)->()) {
        let endpoint: HuddleApi = .groupsCreate(title: title,
                                                description: description,
                                                locationName: locationName,
                                                latitude: latitude,
                                                longitude: longitude,
                                                category: category.rawValue)
       request(endpoint, completion)
    }
    
    func join(group id: Int, completion: @escaping (_ error: String?)->()) {
        request(.groupsJoin(groupId: id), completion)
    }
    
    func removeSelf(fromGroup id: Int, completion: @escaping (_ error: String?)->()) {
        request(.groupsRemoveMe(groupId: id), completion)
    }
    
    func checkSelfIsMember(withinGroup id: Int, completion: @escaping (_ error: String?, _ value: [String:Bool]?)->()) {
        requestJson(.groupsIsMember(groupId: id), completion)
    }
    
    func checkSelfIsOwner(withinGroup id: Int, completion: @escaping (_ error: String?, _ value: [String:Bool]?)->()) {
        requestJson(.groupsIsOwner(groupId: id), completion)
//        request(.groupsIsOwner(groupId: id), completion)
    }
    
    func getGroupMembers(for id: Int, completion: @escaping (_ error: String?, _ groups: [Member]?)->()) {
        request(.groupMembers(groupId: id), completion)
    }
    
    func searchForGroups(id: Int, radius: Int?, completion: @escaping (_ error: String?, _ groups: [Group]?)->()) {
        request(.groupSearch(category: id, radius: radius), completion)
    }
    
    func delete(group id: Int, completion: @escaping (_ error: String?)->()) {
        request(.groupDelete(groupId: id), completion)
    }
    
    // MARK: Categories
    
    func getAllCategories(completion: @escaping (_ error: String?, _ categories: [[String:Int]]?)->()) {
        requestJsonArray(.categoriesAll, completion)
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
