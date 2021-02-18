//
//  LoginViewController.swift
//  Beautify
//
//  Created by Артем Маков on 08.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
     private let vm = LoginViewModel()
        
        
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var createAccountButton: UIButton!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var containerView: UIView!
        @IBOutlet var tapGesture: UITapGestureRecognizer!
        @IBOutlet weak var topForget: NSLayoutConstraint!
        
        
        
        
        

        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            initView()
            initVM()
        }
        
        
        
        
        
        
        
        //MARK:- Init view and fetch View Model
        
        private func initView() {
            //Setup navigationBar
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.isHidden = false
        }
        
        
        private func initVM() {
            vm.signInClosure = { [weak self] in
                guard let self = self else { return }
                self.presentViewController()
            }
            vm.showAlertClosure = { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.loginButton.isEnabled = true
                Alert.showAlert(at: self, title: "Sing In Validation", message: self.vm.message!)
            }
        }
        
        
        
        
        
        
        
        
        
        
        // MARK:- Actions
        
        @IBAction func signinPressed(_ sender: UIButton) {
            updateUI()
            dismissKeyboard()
            activityIndicator.startAnimating()
            loginButton.isEnabled = false
            vm.signInPressed(withEmail: emailTextField.text!, password: passwordTextField.text!)
        }
        private func presentViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: Identifiers.tabBar)
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true)
        }
        

        
        
        @objc private func dismissKeyboard() {
            view.endEditing(true)
            updateUI()
        }

        
        
        
        
        
        
        
        
        private func setupUI() {
            //Setup cornerRadius
            loginButton.layer.cornerRadius = CGFloat(Constants.buttonCornerRadius)
            
            
            //Setup delegates
            emailTextField.addTopBorder()
            emailTextField.addBottomBorder()
            emailTextField.addPrefix(labelText: "Login")
            
            passwordTextField.addBottomBorder()
            passwordTextField.addPrefix(labelText: "Password")
            
            tapGesture.addTarget(self, action: #selector(dismissKeyboard))
            
            activityIndicator.stopAnimating()
            
        }
        
        private func updateUI() {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4) {
                    self.topForget.constant = 50
                }
            }
        }
        
    }


    // MARK:- TextField delegate

    extension LoginViewController: UITextFieldDelegate {
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4) {
                    self.topForget.constant = 170
                }
            }

        }
    }
