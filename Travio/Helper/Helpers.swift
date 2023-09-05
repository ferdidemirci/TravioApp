//
//  Utilities.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import Alamofire

enum AppColor {
    case primaryColor
    case secondaryColor
    case backgroundColor
    case isEnabledColor
    
    func colorValue() -> UIColor {
        switch self {
        case .primaryColor:
            return UIColor(red: 56.0/255.0, green: 173.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        case .secondaryColor:
            return UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        case .backgroundColor:
            return UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        case .isEnabledColor:
            return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        }
    }
}

enum AppFont: String  {
    case light = "Poppins-Light"
    case medium = "Poppins-Medium"
    case regular = "Poppins-Regular"
    case semiBold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
}

func formatISO8601Date(_ dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    } else {
        return nil
    }
}

func isValidEmail(email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}