//
//  LoginViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 14.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    private var isSignIn: Bool? { didSet { signInClosure?() }}
    public  var message : String? { didSet { showAlertClosure?() }}
    
    
    var signInClosure: (()->())?
    var showAlertClosure: (()->())?
    
    
    
    
    
    
    func signInPressed(withEmail email: String, password: String) {
        FBAuthentication.shared.FBSignInUser(withEmail: email, password: password) { [weak self] (isSuccess, error) in
            guard let self = self else { return }
            if !isSuccess {
                self.message = error
            } else {
                self.isSignIn = isSuccess
            }
        }
    }
    
}

