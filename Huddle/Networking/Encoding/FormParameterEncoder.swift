//
//  FormParameterEncoder.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//
//  source: https://stackoverflow.com/questions/29623187/upload-image-with-multipart-form-data-ios-in-swift
//

import Foundation

public struct FormParameterEncoder: ParameterEncoder {
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        // Create the boundary and convert the data to formdata
        let boundary = "----\(UUID().uuidString)"
        let fullData = photoDataToFormData(data: parameters["data"] as! Data,
                                           boundary: boundary,
                                           fileName: parameters["filename"] as! String,
                                           mimeType: parameters["mimetype"] as! String)
        
        // Set the headers
        urlRequest.setValue("multipart/form-data; boundary=" + boundary,
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(fullData.count),
                            forHTTPHeaderField: "Content-Length")
        // Set the Body
        urlRequest.httpBody = fullData
    }
    
    // convert the photo data to form data
    func photoDataToFormData(data:Data, boundary:String, fileName:String, mimeType:String) -> Data {
        var fullData = Data()
        
        // 1 - Start with the boundary
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(using: .utf8, allowLossyConversion: true)!)
        
        // 2 - Add the Content-Disposition
        let lineTwo = "Content-Disposition: form-data; name=\"data\"; filename=\"" + fileName + "\"\r\n"
        fullData.append(lineTwo.data(using: .utf8, allowLossyConversion: true)!)
        
        // 3 - Add the Content-Type
        let lineThree = "Content-Type: \(mimeType)\r\n\r\n"
        fullData.append(lineThree.data(using: .utf8, allowLossyConversion: true)!)
        
        // 4 - Add the actual data
        fullData.append(data as Data)
        
        // 5 - Add a new line
        let lineFive = "\r\n"
        fullData.append(lineFive.data(using: .utf8, allowLossyConversion: true)!)
        
        // 6 - End with the boundary (with -- at the start and end)
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(using: .utf8, allowLossyConversion: true)!)
        
        return fullData
    }
}

