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
    @IBOutlet weak var emailTextFileld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //Hide error label
        errorLabel.alpha = 0
        
        //Style the elements
        Utilities.styleFilledButton(loginButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */ 
    @IBAction func loginTap(_ sender: Any) {
        let loginFieldsError = checkIfFieldsValid()
        
        if (loginFieldsError != nil) {
            
            showErroMessage(loginFieldsError!)
            
        } else {
            
            let email = emailTextFileld.text!
            let password = passwordTextField.text!
            
            Auth.auth().signIn(withEmail: email, password: password) { (loginAuthResult, loginAuthError) in
                    
                if loginAuthError != nil {
                    
                    self.showErroMessage("Can't login with current credentials")
                    
                } else {
                    
                    self.transitionToHome()
                    
                }
            
            }
        }
    }
    
    func checkIfFieldsValid() -> String? {
        //check all fields correct
        if  Utilities.isTextFieldEmpty(emailTextFileld) ||
            Utilities.isTextFieldEmpty(passwordTextField) {
                
            return "Please fill all fields"
            
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Utilities.isPasswordValid(cleanedPassword) {
            //Password validation is failed
            return "Minimal length for password is 6"
        }
        
        return nil
        
    }
    
    func showErroMessage(_ message:String) {
        
           errorLabel.text = message
           errorLabel.alpha = 1
        
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}

//// Put this piece of code anywhere you like
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
