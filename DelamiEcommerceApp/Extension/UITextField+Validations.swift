//
//  UITextField+Validations.swift
//  DelamiEcommerceApp
//
//  Created by Nish-Ranosys on 22/02/18.
//  Copyright © 2018 Nish-Ranosys. All rights reserved.
//

import UIKit

extension UITextField {
    
    func isEmpty() -> Bool {
        let performedString: NSString = (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))! as NSString
        return performedString.length == 0 ? true : false
    }
    
    func isValidEmail() -> Bool {
        let emailRegex: NSString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self.text)
    }
    
    func isValidContactNo() -> Bool {
        let contactRegex: NSString = "^[0-9]{6,16}$"
        let contactTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", contactRegex)
        return contactTest.evaluate(with: self.text)
    }
}
