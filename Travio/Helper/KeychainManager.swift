//
//  KeychainSwiftHelper.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 14.09.2023.
//

import Foundation
import KeychainSwift

class KeychainManager {
    static let shared = KeychainManager()
    
    private let keychain = KeychainSwift()
    
    private init() {}
    
    func saveValue(_ value: String, forKey key: String) {
        keychain.set(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> String? {
        return keychain.get(key)
    }
    
    func deleteValue(forKey key: String) -> Bool {
        return keychain.delete(key)
    }
    
    func getAccessToken() -> String? {
        return getValue(forKey: "accessTokenKey")
    }
    
    func setAccessToken(_ accessToken: String) {
        saveValue(accessToken, forKey: "accessTokenKey")
    }
    
    func getRefreshToken() -> String? {
        return getValue(forKey: "refreshTokenKey")
    }
    
    func setRefreshToken(_ refreshToken: String) {
        saveValue(refreshToken, forKey: "refreshTokenKey")
    }
}
