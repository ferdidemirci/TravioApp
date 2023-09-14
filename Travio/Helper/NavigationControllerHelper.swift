//
//  NavigationControllerHelper.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 14.09.2023.
//

import UIKit
import Foundation

class NavigationControllerHelper {
    static let shared = NavigationControllerHelper()
    
    private init() {}
    
    func startScreenSelection(_ window: UIWindow?) {
        let isAccessTokenPresent = KeychainHelper.shared.getValue(forKey: "accessTokenKey") != nil
        isAccessTokenPresent ? showHomeScreen(window) : showLoginScreen(window)
    }
    
    func showLoginScreen(_ window: UIWindow?) {
        let loginVC = LoginVC()
        let rootVC = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func showHomeScreen(_ window: UIWindow?) {
        let rootVC = MainTabBarC()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func logout(_ windowScene: UIWindowScene) {
        guard let window = windowScene.windows.first else { return }
        NavigationControllerHelper.shared.showLoginScreen(window)
    }
}
