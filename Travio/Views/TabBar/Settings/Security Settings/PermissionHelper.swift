//
//  PermissionHelper.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 11.09.2023.
//

import Foundation
import AVFoundation
import Photos
import CoreLocation
import UIKit

class PermissionHelper {
    
    let shared = PermissionHelper()
    
    static func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    static func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                let granted = (status == .authorized || status == .limited)
                completion(granted)
            }
        }
    }
    
    static func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                completion(true)
            case .denied, .restricted:
                completion(false)
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
}
