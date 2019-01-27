//
//  EndPointType.swift
//  Huddle
//
//  Created by Dan Mitu on 1/21/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//
//  Source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}
