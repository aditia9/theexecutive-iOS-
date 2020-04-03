//
//  LoginViewModel.swift
//  DelamiEcommerceApp
//
//  Created by Nish-Ranosys on 22/02/18.
//  Copyright © 2018 Nish-Ranosys. All rights reserved.
//

import UIKit

struct ApiError {
    var statusCode: Int?
    var message: String?
}

struct ValidationRule {
    var message: String?
}

class LoginViewModel: NSObject {
    // MARK: - view binding variables
    var emailID: String?
    var password: String?
    
    // MARK: - other variables
    var rule = ValidationRule()
    var apiError = ApiError()
    
    var fbUserInfo: NSDictionary = [:]
}

extension LoginViewModel {
    
    // MARK: - API Call
    func requestForCustomerLogin(success: @escaping((_ response: AnyObject) -> Void), failure: @escaping((_ error: NSError?) -> Void)) {
        UserModel().doLogin(email: emailID!, password: password!, success: { (response) in
            success(response)
            
        }, failure: { (error) in
            self.apiError.statusCode = error?.code
            self.apiError.message = error?.userInfo["error"] as? String ?? error?.localizedDescription
            failure(error)
        })
    }
    
    // MARK: - IsEmailAvailable API Call
    func requestForIsEmailAvailable(email: String, success: @escaping((_ response: Bool) -> Void), failure: @escaping((_ error: NSError) -> Void)) {
        UserModel().isEmailAvailable(email: email, success: { (response) in
            success(response)
        }, failure: { (error) in
            failure (error!)
        })
    }
    
    // MARK: - Social Login API Call
    func requestForSocialLogin(email: String, token: String, loginType: String, success: @escaping(() -> Void), failure: @escaping((_ error: NSError) -> Void)) {
        UserModel().requestForSocialLogin(email: email, token: token, loginType: loginType, success: {
            success()
        }, failure: { (error) in
            failure (error!)
        })
    }
    
    func mergeGuestCartToUser(guestCartId: String, success: @escaping ((_ response: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        ConnectionManager().mergeGuestCartToUserCart(guestCartID: guestCartId, success: success, failure: failure)
    }
            
    // MARK: - Validation
    func performValidation() -> Bool {
        if emailID == nil {
            emailID = ""
        } else if password == nil {
            password = ""
        }
        if (emailID?.isEmpty)! {
            rule.message = AlertValidation.Empty.email.localized()
            return false
        }
        if (password?.isEmpty)! {
            rule.message = AlertValidation.Empty.password.localized()
            return false
        }
        if !(emailID?.isValidEmail())! {
            rule.message = AlertValidation.Invalid.email.localized()
            return false
        } else {
            return true
        }
    }
    
    func setFBUserModal(resultDictionary: NSDictionary) -> RegisterViewModal {
        let viewModelRegister = RegisterViewModal()
        
        viewModelRegister.firstName = (resultDictionary.value(forKey: "first_name") as? String)!
        viewModelRegister.lastName = (resultDictionary.value(forKey: "last_name") as? String)!
        viewModelRegister.emailID = (resultDictionary.value(forKey: "email") as? String)!
        viewModelRegister.loginType = LoginType.social.rawValue
//        viewModelRegister.age = (resultDictionary.value(forKeyPath: "age_range.min") as? Int)!
//        user.gender = (resultDictionary.value(forKeyPath: "gender") as? String)!
        
        return viewModelRegister
    }
}
