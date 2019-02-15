//
//  Utility.swift
//  Huddle
//
//  Created by Dan Mitu on 1/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit
import AVFoundation

enum SubmissionStatus {
    case waitingForInput
    case submitting
    case submitted
}

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
