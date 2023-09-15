//
//  Extensions.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import UIKit

extension UIViewController {
    typealias closure = (Bool) -> Void
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showDeleteAlert(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }

        let deleteConfirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteConfirmAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
    func addArrangedSubviews(_ stackViews: UIView...) {
        stackViews.forEach {
            self.addArrangedSubviews($0)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 8
        clipsToBounds = false
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func addCornerRadius(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }
}

extension IndexPath {
    func toString() -> String {
        return "\(section),\(row)"
    }

    init(from string: String) {
        let components = string.split(separator: ",").map { Int($0)! }
        self.init(row: components[1], section: components[0])
    }
}
