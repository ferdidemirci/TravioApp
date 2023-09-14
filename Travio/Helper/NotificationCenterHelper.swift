//
//  NotificationCenterHelper.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 13.09.2023.
//

import Foundation

class NotificationCenterHelper {
    static let shared = NotificationCenterHelper()
    
    private init() {}

    func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("VisitUpdateNotification"), object: nil)
    }

    func addObserver(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name("VisitUpdateNotification"), object: nil)
    }

    func removeObserver(observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name("VisitUpdateNotification"), object: nil)
    }
}
