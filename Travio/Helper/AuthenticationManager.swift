//
//  NavigationControllerHelper.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 14.09.2023.
//

import UIKit
import Foundation
import Alamofire

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private let keychainManager = KeychainManager.shared
    private init() {}
    
    func startScreenSelection(_ window: UIWindow?) {
        showLaunchScreen(window)
        guard let accessToken = keychainManager.getValue(forKey: "accessTokenKey") else {
            showLoginScreen(window)
            return
        }

        isAccessTokenValid(accessToken) { isValid in
            if isValid {
                self.showHomeScreen(window)
            } else {
                guard let refreshToken = self.keychainManager.getValue(forKey: "refreshTokenKey") else {
                    self.showLoginScreen(window)
                    return
                }
                
                self.refreshToken(refreshToken) { refreshed in
                    if refreshed {
                        self.showHomeScreen(window)
                    } else {
                        self.showLoginScreen(window)
                    }
                }
            }
        }
    }
    
    func isAccessTokenValid(_ accessToken: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.routerRequest(request: Router.me) { (result: Result<Me, Error>) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func refreshToken(_ refreshToken: String, completion: @escaping (Bool) -> Void) {
        guard let refreshToken = keychainManager.getRefreshToken() else { return }
        let param: Parameters = ["refresh_token": refreshToken]
        
        NetworkManager.shared.routerRequest(request: Router.refreshToken(parameters: param)) { (result: Result<TokenResponse, Error>) in
            switch result {
            case .success(let token):
                self.keychainManager.saveValue(token.accessToken, forKey: "accessTokenKey")
                self.keychainManager.saveValue(token.refreshToken, forKey: "refreshTokenKey")
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func showLaunchScreen(_ window: UIWindow?) {
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }
    
    func showLoginScreen(_ window: UIWindow?) {
        let loginVC = LoginVC()
        let rootVC = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = rootVC
    }
    
    func showHomeScreen(_ window: UIWindow?) {
        let rootVC = MainTabBarC()
        window?.rootViewController = rootVC
    }
    
    func logout(_ windowScene: UIWindowScene) {
        guard let window = windowScene.windows.first else { return }
        showLoginScreen(window)
    }
    
}
