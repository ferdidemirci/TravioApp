//
//  SecuritySettingsVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 5.09.2023.
//

import Foundation
import Alamofire
import AVFoundation
import Photos
import CoreLocation

class SecuritySettingsVM {
    let sectionTitles = ["Change Password", "Privacy"]
    let cellTitles = [["New Password", "New Password Confirm"], ["Camera", "Photo Library", "Location"]]
    var passwords = ["Password": "", "confirmPassword": ""]
    
    var cameraPermissionEnabled = false
    var photoLibraryPermissionEnabled = false
    var locationPermissionEnabled = false
    
    func changePassword(newPassword: Parameters, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.routerRequest(request: Router.changePassword(parameters: newPassword)) { (result: Result<Response, Error>) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func requestPermissions(completion: @escaping () -> Void) {
        PermissionHelper.requestCameraPermission { [weak self] granted in
            guard let self = self else { return }
            self.cameraPermissionEnabled = granted
            completion()
        }
        PermissionHelper.requestPhotoLibraryPermission { [weak self] granted in
            guard let self = self else { return }
            self.photoLibraryPermissionEnabled = granted
            completion()
        }
        PermissionHelper.requestLocationPermission { [weak self] granted in
            guard let self = self else { return }
            self.locationPermissionEnabled = granted
            completion()
        }
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized, .restricted:
            cameraPermissionEnabled = true
        case .denied, .notDetermined:
            cameraPermissionEnabled = false
        @unknown default:
            cameraPermissionEnabled = false
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .restricted:
            photoLibraryPermissionEnabled = true
        case .denied, .notDetermined:
            photoLibraryPermissionEnabled = false
        case .limited:
            photoLibraryPermissionEnabled = false
        @unknown default:
            photoLibraryPermissionEnabled = false
        }
    }
    
    func checkLocationPermission() {
        let locationManager = CLLocationManager()
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationPermissionEnabled = true
        case .denied, .restricted:
            locationPermissionEnabled = false
        case .notDetermined:
            locationPermissionEnabled = false
        @unknown default:
            locationPermissionEnabled = false
        }
    }
}
