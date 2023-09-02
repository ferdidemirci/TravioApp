//
//  Extensions.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import Foundation
import UIKit

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
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 20
        clipsToBounds = false
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIColor {

     class func applyGradient(colors: [UIColor], bounds:CGRect) -> UIColor {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)

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

extension UIButton {
    func centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
            if imageAboveText {
                // https://stackoverflow.com/questions/2451223/#7199529
                guard
                    let imageSize = imageView?.image?.size,
                    let text = titleLabel?.text,
                    let font = titleLabel?.font else { return }

                let titleSize = text.size(withAttributes: [.font: font])

                let titleOffset = -(imageSize.height + spacing)
                titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)

                let imageOffset = -(titleSize.height + spacing)
                imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)

                let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
                contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
            } else {
                let insetAmount = spacing / 2
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
                contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
            }
        }
}

