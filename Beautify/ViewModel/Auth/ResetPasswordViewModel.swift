//
//  ResetPasswordViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 16.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class ResetPasswordViewModel {
    
    
    var message     : String? { didSet { showAlertClosure?() }}
    
    var isSuccess   = true

    var showAlertClosure: (()->())?
    
    
    
    
    
    
    
    
    
    
    func resetPassword(email: String) {
        FBAuthentication.shared.resetPassword(email: email) { (isSuccess, error) in
            if isSuccess {
                self.isSuccess = isSuccess
                self.message   = "We sent an email to reset your password, Thanks to check your email"
            } else {
                self.isSuccess = isSuccess
                self.message   = error
            }
        }
    }
    
}
