//
//  SignUpViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 14.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class SignupViewModel {
    
    private var isSignup      : Bool? { didSet { signupClosure?() }}
    public  var messageAlert  : String? {  didSet { showAlertClosure?() }}
    
    
    
    
    var signupClosure   : (()->())?
    var showAlertClosure: (()->())?
    
    
    
    
    
    
    
    func signUpPressed(firstName: String, lasName: String, withEmail email: String, password: String, profileImage: UIImage?) {
        FBAuthentication.shared.FBSignUpUser(firstName: firstName, lasName: lasName, withEmail: email, password: password, profileImage: profileImage) { [weak self] (isSuccess, error) in
            guard let self = self else { return }
            if !isSuccess {
                self.messageAlert = error
            } else {
                self.isSignup = isSuccess
            }
        }
    }
    
}
