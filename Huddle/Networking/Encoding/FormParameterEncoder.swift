//
//  FormParameterEncoder.swift
//  Huddle
//
//  Created by Dan Mitu on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//
//  source: https://gist.github.com/nolanw/dff7cc5d5570b030d6ba385698348b7c
//

/* Example Request from Postman...
 
 POST /members/profile/upload HTTP/1.1
 Host: debug1-env.m7bhnnyn8p.us-west-2.elasticbeanstalk.com
 cache-control: no-cache
 Postman-Token: bae52936-d6e3-4983-8316-c8de99ea5cdf
 Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
 
 Content-Disposition: form-data; name="data"; filename="/Users/danmitu/Downloads/6357600113572837231773916132_michael-scott-s-top-tantrums.png
 
 
 ------WebKitFormBoundary7MA4YWxkTrZu0gW--
 */

import Foundation

public struct FormParameterEncoder: ParameterEncoder {
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        let lineBreak = "\r\n"
        var body = Data()
        let boundary = "----\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)\r\n", forHTTPHeaderField: "Content-Type")
        
//        for (key, value) in parameters {
//            body.append("--\(boundary + lineBreak)".utf8Data)
//            switch value {
//            case let stringValue as String:
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".utf8Data)
//                body.append("\(stringValue + lineBreak)".utf8Data)
//            case let stringConvertible as CustomStringConvertible:
//                let stringValue = stringConvertible.description
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".utf8Data)
//                body.append("\(stringValue + lineBreak)".utf8Data)
//            case let media as Media:
        let string = "data"
//                body.append("--\(boundary + lineBreak)".utf8Data)
                body.append("Content-Disposition: form-data; name=\"\(string)\"; filename=\"\(parameters["filename"] as! String)\"\(lineBreak)".utf8Data)
                body.append("Content-Type: \(parameters["mimetype"] as! String + lineBreak + lineBreak)".utf8Data)
//                let string = String(data: parameters["data"] as! Data, encoding: .utf8)
        body.append(parameters["data"] as! Data)
                body.append(lineBreak.utf8Data)
//            default:
//                throw NetworkError.encodingFailed
//            }
            body.append("--\(boundary)--\(lineBreak)".utf8Data)
//        }
        print(body)
        urlRequest.httpBody = body

    }
    
    
}

fileprivate extension String {
    
    var utf8Data: Data! {
        return self.data(using: .utf8)
    }
    
}
