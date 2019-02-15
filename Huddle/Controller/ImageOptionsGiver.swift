//
//  ImageOptionsGiver.swift
//  Huddle
//
//  Created by Dan Mitu on 2/2/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

/*
 If you ever want to go through the flow of getting an image from the user, use this protocol on your UIViewController and use the UIImagePickerControllerDelegate to retrieve the image.
*/

protocol ImageOptionsGiver: class, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImageOptions()
    
}

extension ImageOptionsGiver where Self: UIViewController {
    
    func presentImageOptions() {
        let imageOptionsSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraOption = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            getCameraPermissionIfNeeded(from: self, then: { [weak self] granted in
                guard granted else { return }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.sourceType = .camera
                    imagePickerController.allowsEditing = true
                    self?.present(imagePickerController, animated: true)
                }
            })
        })
        
        let photoLibraryOption = UIAlertAction(title: "Photos", style: .default, handler: { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self;
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = true
                self?.present(imagePickerController, animated: true, completion: nil)
            }
        })
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel)
        
        imageOptionsSheet.addAction(cameraOption)
        imageOptionsSheet.addAction(photoLibraryOption)
        imageOptionsSheet.addAction(cancelOption)
        
        present(imageOptionsSheet, animated: true)
    }
    
}

