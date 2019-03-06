//
//  FormParameterEncoder.swift
//  Huddle
//
//  Created by Dan Mitu on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//
//  source: https://stackoverflow.com/questions/29623187/upload-image-with-multipart-form-data-ios-in-swift
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
        
        // Create the boundary and convert the data to formdata
        let boundary = "----\(UUID().uuidString)"
        let fullData = photoDataToFormData(data: parameters["data"] as! Data, boundary:boundary, fileName:parameters["filename"] as! String)
        
        // Set the headers
        urlRequest.setValue("multipart/form-data; boundary=" + boundary,
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(fullData.count),
                            forHTTPHeaderField: "Content-Length")
        // Set the Body
        urlRequest.httpBody = fullData
    }
    
    // convert the photo data to form data
    func photoDataToFormData(data:Data,boundary:String,fileName:String) -> Data {
        var fullData = Data()
        
        // 1 - Start with the boundary
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(using: .utf8, allowLossyConversion: true)!)
        
        // 2 - Add the Content-Disposition
        let lineTwo = "Content-Disposition: form-data; name=\"data\"; filename=\"" + fileName + "\"\r\n"
        fullData.append(lineTwo.data(using: .utf8, allowLossyConversion: true)!)
        
        // 3 - Add the Content-Type
        let lineThree = "Content-Type: image/jpeg\r\n\r\n"
        fullData.append(lineThree.data(using: .utf8, allowLossyConversion: true)!)
        
        // 4 - Add the actual data
        fullData.append(data as Data)
        
        // 5 - Add a new line
        let lineFive = "\r\n"
        fullData.append(lineFive.data(using: .utf8, allowLossyConversion: true)!)
        
        // 6 - The end. make sure this is -- and then the boundary and then -- again
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(using: .utf8, allowLossyConversion: true)!)
        
        return fullData
    }
    
    
}

