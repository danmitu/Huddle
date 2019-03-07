//
//  Media.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//
//  source: https://github.com/Kilo-Loco/URLSessionMPFD
//

import UIKit

struct Media {
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImageAsJPEG image: UIImage) {
        self.mimeType = "image/jpeg"
        self.filename = "\(UUID().uuidString).jpeg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
    
}
