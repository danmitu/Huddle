//
//  NetworkEnvironment.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//
//  Source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

enum HuddleApi: EndPointType {
    
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
    case eventsRead(eventId: Int)
    case eventsCreate(groupId: Int, title: String, description: String, location: String, latitude: Double, longitude: Double, start: String, end: String)
    case eventsUpdate(event: Event)
    case eventsDelete(eventId: Int)
    case eventsRSVP(eventId: Int, status: Bool)
    case eventsCalendar
    case eventsForGroup(groupId: Int)
    case groupsRead(groupId: Int)
    case groupsCreate(title: String, description: String, locationName: String, latitude: Double, longitude: Double, category: Int)
    case groupsMine
    case groupsIsMember(groupId: Int)
    case groupsIsOwner(groupId: Int)
    case groupsOther(id: Int)
    case groupsJoin(groupId: Int)
    case groupsRemoveMe(groupId: Int)
    case groupUpdate(group: Group)
    case groupMembers(groupId: Int)
    case groupSearch(category: Int, radius: Int?)
    case groupDelete(groupId: Int)
    case categoriesAll
    
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
        case .eventsRead: return "events/read"
        case .eventsCreate: return "events/create"
        case .eventsUpdate: return "events/update"
        case .eventsDelete: return "events/delete"
        case .eventsRSVP: return "events/rsvp"
        case .eventsCalendar: return "events/calendar"
        case .eventsForGroup: return "events/readall"
        case .groupsRead: return "groups/read"
        case .groupsCreate: return "groups/create"
        case .groupsMine: return "groups/mygroups"
        case .groupsIsMember: return "groups/ismember"
        case .groupsIsOwner: return "groups/isowner"
        case .groupsJoin: return "groups/join"
        case .groupsRemoveMe: return "groups/removeme"
        case .groupsOther: return "groups/membergroups"
        case .groupUpdate: return "groups/update"
        case .groupMembers: return "groups/members"
        case .groupSearch: return "categories/groups"
        case .groupDelete: return "groups/delete"
        case .categoriesAll: return "categories/all"
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
        case .eventsRead: return .get
        case .eventsCreate: return .post
        case .eventsUpdate: return .put
        case .eventsDelete: return .delete
        case .eventsRSVP: return .post
        case .eventsCalendar: return .get
        case .eventsForGroup: return .get
        case .groupsRead: return .get
        case .groupsCreate: return .post
        case .groupsMine: return .get
        case .groupsIsMember: return .get
        case .groupsIsOwner: return .get
        case .groupsOther: return .get
        case .groupsJoin: return .post
        case .groupsRemoveMe: return .delete
        case .groupUpdate: return .put
        case .groupMembers: return .get
        case .groupSearch: return .get
        case .groupDelete: return .delete
        case .categoriesAll: return .get
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
            return .requestParameters(bodyParameters: ["filename":media.filename,
                                                       "data":media.data,
                                                       "mimetype":media.mimeType],
                                      bodyEncoding: .formDataEncoding,
                                      urlParameters: nil)
        
        case .eventsRead(eventId: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["eventid":id])
        
        case .eventsCreate(groupId: let id,
                           title: let t,
                           description: let d,
                           location: let l,
                           latitude: let lat,
                           longitude: let lng,
                           start: let s,
                           end: let e):
            return .requestParameters(bodyParameters: ["GroupID":id,
                                                       "Title":t,
                                                       "Description":d,
                                                       "Location":l,
                                                       "Latitude":lat,
                                                       "Longitude":lng,
                                                       "Start":s,
                                                       "End":e
                                                       ], bodyEncoding: .jsonEncoding, urlParameters: nil)
            
        case .eventsUpdate(event: let e):
            return .requestParameters(bodyParameters: ["ID": e.id,
                                                       "Title": e.name,
                                                       "Description": e.description,
                                                       "Location": e.location.name,
                                                       "Latitude": Double(e.location.location.coordinate.latitude),
                                                       "Longitude": Double(e.location.location.coordinate.longitude),
                                                       "Start": PreferredDateFormat.describe(e.start, using: .format1)!,
                                                       "End": PreferredDateFormat.describe(e.end, using: .format1)!
                                                       ], bodyEncoding: .jsonEncoding,
                                                          urlParameters: nil)
        case .eventsDelete(eventId: let id):
            return .requestParameters(bodyParameters: ["ID": id], bodyEncoding: .jsonEncoding, urlParameters: nil)
            
        case .eventsRSVP(eventId: let id, status: let status):
            return .requestParameters(bodyParameters: ["ID":id, "Attending":status],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
            
        case .eventsCalendar:
            return .request
        
        case .eventsForGroup(groupId: let id):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["groupid":id])
            
        case .groupsRead(groupId: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["id":id])
        
        case .groupsCreate(title: let title,
                           description: let description,
                           locationName: let locationName,
                           latitude: let latitude,
                           longitude: let longitude,
                           category: let category):
            return .requestParameters(bodyParameters: ["Title":title,
                                                       "Description":description,
                                                       "Location":locationName,
                                                       "Latitude":latitude,
                                                       "Longitude":longitude,
                                                       "CategoryID":category
                                                       ], bodyEncoding: .jsonEncoding, urlParameters: nil)
            
        case .groupsMine:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
            
        case .groupsIsMember(groupId: let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["groupid": id])
            
        case .groupsIsOwner(groupId: let id):
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
            
        case .groupUpdate(group: let group):
            return .requestParameters(bodyParameters: ["ID":group.id,
                                                       "Title":group.title,
                                                       "Description":group.description,
                                                       "Location":group.location.name,
                                                       "Latitude":group.location.location.coordinate.latitude,
                                                       "Longitude":group.location.location.coordinate.longitude,
                                                       "CategoryID": group.category.rawValue
                                                       ],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        
        case .groupMembers(groupId: let id):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["id":id])
            
        case .groupSearch(category: let category, radius: let radius):
            var urlParameters: Dictionary<String, Any> = [:]
            urlParameters["id"] = category
            if (radius != nil) {
                urlParameters["radius"] = radius
            }
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: urlParameters)

        case .groupDelete(groupId: let id):
            return .requestParameters(bodyParameters: ["ID":id], bodyEncoding: .jsonEncoding, urlParameters: nil)
            
            
        case .categoriesAll:
            return .request
        }
    }

}

