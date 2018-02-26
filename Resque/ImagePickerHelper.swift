//
//  File.swift
//  Resque
//
//  Created by Roback, Jerry on 1/9/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

typealias ImagePickerHelperCompletion = ((UIImage?) -> Void)!

class ImagePickerHelper: NSObject {
    weak var viewController: UIViewController!
    var completion: ImagePickerHelperCompletion
    
    init(viewController: UIViewController, completion: ImagePickerHelperCompletion) {
        self.viewController = viewController
        self.completion = completion
        
        super.init()
        
        // Distinuishes Actionsheet messaging based on the source of the tap
        if viewController.navigationItem.title == "Resque" || viewController.navigationItem.title == "New Search" {
            self.showPhotoSourceSelection(title: "Select a Photo to Search From", message: "Access your photo library or take a new photo.")
        } else {
            self.showPhotoSourceSelection(title: "Choose New Profile Photo", message: "Access your photo library or take a new photo.")
        }
    }
    
    func showPhotoSourceSelection(title: String, message: String?) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showImagePicker(sourceType: .camera)
        })
        let photosLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.showImagePicker(sourceType: .photoLibrary)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photosLibraryAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        
        // Image Picker Cosmetics
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = UIColor(red: 0.3176, green: 0.6549, blue: 0.9765, alpha: 1.0) /* #51a7f9 - Background Color */
        imagePicker.navigationBar.tintColor = UIColor.white // Cancel button ~ any UITabBarButton items
        imagePicker.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ] // Title color
        
        viewController.present(imagePicker, animated: true, completion: nil)
    }
}

extension ImagePickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        viewController.dismiss(animated: true, completion: nil)
        completion(image)
    }
}
