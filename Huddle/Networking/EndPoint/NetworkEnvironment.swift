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
    case login(email: String, password: String)
}

extension HuddleApi: EndPointType {
    
    var baseURL: URL {
        return URL(string: "http://debug1-env.m7bhnnyn8p.us-west-2.elasticbeanstalk.com/")!
    }
    
    var path: String {
        switch self {
        case .login: return "members/login"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login: return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(email: let email, password: let password):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["email":email, "password":password])
        }
    }

}

