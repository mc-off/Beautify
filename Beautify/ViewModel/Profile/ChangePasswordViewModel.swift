//
//  ChangePasswordViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 23.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class ChangePasswordViewModel {
    
    var message = String() { didSet { changePasswordClosure?() }}
    
    
    var changePasswordClosure: (()->())?
    
    
    func chnagePassword(password: String, repassword: String) {
        if password == repassword {
            FBAuthentication.shared.changePassword(password: password) { [weak self] (isSuccess, error) in
                guard let self = self else { return }
                self.message = isSuccess ? "Пароль обновлен" : error!
            }
        } else {
            message = "Введенные пароли не совпадают"
        }
    }
    
}


//test string
