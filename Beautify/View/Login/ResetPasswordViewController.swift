//
//  SignUpViewController.swift
//  Beautify
//
//  Created by Артем Маков on 11.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ResetPasswordViewController: UIViewController {
    
    let vm = ResetPasswordViewModel()
        
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var resetButton: UIButton!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        @IBOutlet var tapGesture: UITapGestureRecognizer!
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            initVM()
        }
        

        
        
        
        
        
        
        // MARK:- Init view model
        
        private func initVM() {
            vm.showAlertClosure = { [weak self] in
                guard let self = self else { return }
                if self.vm.isSuccess {
                    self.navigationController?.popToRootViewController(animated: true)
                    Alert.showAlert(at: self, title: self.vm.message!, message: "")
                } else {
                    self.activityIndicator.stopAnimating()
                    self.resetButton.isEnabled = true
                    Alert.showAlert(at: self, title: self.vm.message!, message: "")
                }
                
            }
        }
        
        
        
        
        
        
        
        
        // MARK:- Actions
        
        @IBAction func resetButtonPressed(_ sender: UIButton) {
            activityIndicator.startAnimating()
            sender.isEnabled = false
            vm.resetPassword(email: emailTextField.text!)
        }
        
        @objc private func dismissKeyboard() {
            view.endEditing(true)
        }
        
        
        
        
        
        
        
        
        
        
        
        private func setupUI() {
            //Setup cornerRadius
            resetButton.layer.cornerRadius = CGFloat(Constants.buttonCornerRadius)
            
            //Setup backgroundColor
            emailTextField.addTopBorder()
            emailTextField.addBottomBorder()
            emailTextField.addPrefix(labelText: "Логин")
        
            
            tapGesture.addTarget(self, action: #selector(dismissKeyboard))
            
            
        }
    }
