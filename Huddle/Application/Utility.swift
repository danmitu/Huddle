//
//  Utility.swift
//  Huddle
//
//  Created by Dan Mitu on 1/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

func isValidEmail(testStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

// MARK: - Device Permissions

/// Presents an alert for when the user hasn't given permission to use a device. It gives them an option to visit the settings page where they can change their permissions.
///
/// - Parameters:
///   - deniedDeviceDescription: e.g. "Camera", "Photo Library", "Microphone"
///   - presentingViewContoller: The view controller from which the alert is presented.
func presentAlertForDeniedPermission(deniedDeviceDescription: String, presentingViewContoller: UIViewController) {
    let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    let titleString = "\(appName) was denied permission to use the \(deniedDeviceDescription)."
    let messageString = "You can give permission in settings."
    
    let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
    
    // Takes the user to the settings screen where they can give the app permission.
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    // Closes the UIAlert
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

    alertController.addAction(settingsAction)
    alertController.addAction(cancelAction)
    presentingViewContoller.present(alertController, animated: true, completion: nil)
}

/// Requests permission to use the camera. If the user previously denied permission, they're presented an alert telling them to go to settings.
///
/// - Parameters:
///   - viewController: The view controller from which an alert is presented.
///   - completionHandler: Passes true/false if the user was given permission.
func getCameraPermissionIfNeeded(from viewController: UIViewController, then completionHandler: @escaping (_ granted: Bool)->()) {
    let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    switch cameraAuthorizationStatus {
    case .authorized:
        completionHandler(true)
    case .denied, .restricted:
        presentAlertForDeniedPermission(deniedDeviceDescription: "Camera", presentingViewContoller: viewController)
        completionHandler(false)
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            completionHandler(granted)
        }
    }
}

extension String {
    var bool: Bool? {
        let lowercaseSelf = self.lowercased()
        
        switch lowercaseSelf {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

enum PreferredDateFormat: String {
    
    /// e.g. Friday, 3/1/19 5:45 AM
    case format0 = "EEEE, M/d/yy H:mm a"
    
    /// e.g. 2020-12-31 11:59:59
    case format1 = "yyyy-MM-dd HH:mm:ss"
    
    /// e.g. Sun, Mar 3, 2019, 11:50 PM
    case format2 = "EEE, MMM d, yyyy, h:mm a"

    static func describe(_ date: Date, using format: PreferredDateFormat) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
}

enum PreferredLocationFormat {
    
    /// e.g. ["SE 7th Ave", "Portland, OR", "97214"]
    case address
    
    case shortAddress
    
    /// e.g. ["Southeast Warehouse District", "SE 7th Ave", "Portland", "OR", "United States", "97214"]
    case everything
    
    /// e.g. ["Portland", "OR"]
    case cityState
    
    static func describe(_ location: CLLocation, using format: PreferredLocationFormat, _ completion: @escaping ([[String]]?)->()) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard error == nil else { completion(nil); return }
            guard let placemarks = placemarks else { completion(nil); return }
            completion(
                placemarks.map { PreferredLocationFormat.describe(placemark: $0, using: format) }
            )
        })
    }
    
    private static func describe(placemark: CLPlacemark, using format: PreferredLocationFormat) -> [String ]{
        var buffer = [String]()
        switch format {
        case .address:
            if let f = placemark.thoroughfare { buffer.append(f); }
            if let l = placemark.locality, let a = placemark.administrativeArea {
                buffer.append("\(l), \(a)")
            }
            if let p = placemark.postalCode { buffer.append(p) }
        case .shortAddress:
            if let f = placemark.thoroughfare { buffer.append(f); }
            if let l = placemark.locality, let a = placemark.administrativeArea {
                buffer.append("\(l), \(a)")
            }
        case .cityState:
            if let l = placemark.locality { buffer.append(l) }
            if let a = placemark.administrativeArea { buffer.append(a) }
        case .everything:
            if let s = placemark.subLocality { buffer.append(s) }
            if let f = placemark.thoroughfare { buffer.append(f) }
            if let l = placemark.locality { buffer.append(l) }
            if let a = placemark.administrativeArea { buffer.append(a) }
            if let c = placemark.country { buffer.append(c) }
            if let p = placemark.postalCode { buffer.append(p) }
        }
        return buffer
    }
}

