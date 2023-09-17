//
//  ImagePickerHelper.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 15.09.2023.
//

import UIKit

class ImagePickerHelper {
    
    static let shared = ImagePickerHelper()
    
    func showImageSourceOptions(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.buttonMakeYourChoice(from: viewController, source: .camera)
        }

        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.buttonMakeYourChoice(from: viewController, source: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func buttonMakeYourChoice(from viewController: UIViewController, source: ImageSource) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        
        viewController.present(imagePicker, animated: true)
    }
}
