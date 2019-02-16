//
//  NetworkEnvironment.swift
//  Huddle
//
//  Created by Dan Mitu on 1/21/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//
//  Source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

enum HuddleApi {
    case membersReadUser(id: Int)
    case membersRead
    case membersUpdate(member: Member)
    case membersLogin(email: String, password: String)
    case membersLogout
    case membersCreateAccount(email: String, password: String, fullName: String)
    case membersUpdatePassword(oldPassword: String, newPassword: String)
    case membersProfileImage
    case membersNotMeProfileImage(id: Int)
    case membersProfileImageUpload(media: Media)
    case groupsRead(groupId: Int)
    case groupsMine
    case groupsIsMember(groupId: Int)
    case groupsOther(id: Int)
    case groupsJoin(groupId: Int)
    case groupsRemoveMe(groupId: Int)
}

extension HuddleApi: EndPointType {
    
    var baseURL: URL {
        return URL(string: "http://debug1-env.m7bhnnyn8p.us-west-2.elasticbeanstalk.com/")!
    }
    
    var path: String {
        switch self {
        case .membersReadUser: return "members/readuser"
        case .membersRead: return "members/read"
        case .membersUpdate: return "members/update"
        case .membersLogin: return "members/login"
        case .membersLogout: return "members/logout"
        case .membersCreateAccount: return "members/create"
        case .membersUpdatePassword: return "members/changepassword"
        case .membersProfileImage: return "members/profile/download"
        case .membersNotMeProfileImage: return "members/userprofile/download"
        case .membersProfileImageUpload: return "members/profile/upload"
        case .groupsRead: return "groups/read"
        case .groupsMine: return "groups/mygroups"
        case .groupsIsMember: return "groups/ismember"
        case .groupsJoin: return "groups/join"
        case .groupsRemoveMe: return "groups/removeme"
        case .groupsOther: return "groups/membergroups"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .membersReadUser: return .get
        case .membersRead: return .get
        case .membersUpdate: return .put
        case .membersLogin: return .get
        case .membersLogout: return .get
        case .membersCreateAccount: return .post
        case .membersUpdatePassword: return .post
        case .membersProfileImage: return .get
        case .membersNotMeProfileImage: return .get
        case .membersProfileImageUpload: return .post
        case .groupsRead: return .get
        case .groupsMine: return .get
        case .groupsIsMember: return .get
        case .groupsOther: return .get
        case .groupsJoin: return .post
        case .groupsRemoveMe: return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
            
        case .membersReadUser(id: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["id":id])
            
        case .membersRead:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: nil)
            
        case .membersUpdate(member: let member):
            return .requestParameters(bodyParameters: ["Name":member.name ?? "",
                                                       "Email":member.email,
                                                       "Bio":member.bio ?? "",
                                                       "Location":member.homeLocation?.name ?? "",
                                                       "Latitude":member.homeLocation?.location.coordinate.latitude ?? "",
                                                       "Longitude":member.homeLocation?.location.coordinate.longitude ?? "",
                                                       "PublicLocation": member.publicLocation,
                                                       "PublicGroup": member.publicGroup
                                                       ],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
            
        case .membersLogin(email: let email, password: let password):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["email":email, "password":password])
            
        case .membersLogout:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
            
        case .membersCreateAccount(email: let email, password: let password, fullName: let fullName):
            return .requestParameters(bodyParameters: ["email": email, "password":password, "name":fullName],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
            
        case .membersUpdatePassword(oldPassword: let oldPassword, newPassword: let newPassword):
            return .requestParameters(bodyParameters: ["password":oldPassword, "newPassword":newPassword],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
            
        case .membersProfileImage:
            return .request
        
        case .membersNotMeProfileImage(id: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["id":id])
        
        case .membersProfileImageUpload(media: let media):
            return .requestParameters(bodyParameters: ["profileImage":media],
                                      bodyEncoding: .formDataEncoding,
                                      urlParameters: nil)
            
        case .groupsRead(groupId: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["id":id])
            
        case .groupsMine:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
            
        case .groupsIsMember(groupId: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["groupid": id])
            
        case .groupsOther(id: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["memberid":id])
            
        case .groupsJoin(groupId: let id):
            return .requestParameters(bodyParameters: ["ID":id],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
            
        case .groupsRemoveMe(groupId: let id):
            return .requestParameters(bodyParameters: ["ID":id],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        }
    }

}

