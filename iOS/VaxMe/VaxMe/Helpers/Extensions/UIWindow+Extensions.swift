//
//  UIWindow+Extensions.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/13/21.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
