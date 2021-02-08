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

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var SecondNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        //Hide error label
        ErrorLabel.alpha = 0
        
        //Style the elements
        Utilities.styleFilledButton(SignUpButton)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Check if field is correct
    func isTextFieldEmpty(_ textField:UITextField) -> Bool {
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    func validateFields() -> String? {
        
        //check all fields correct
        if  isTextFieldEmpty(FirstNameTextField) ||
            isTextFieldEmpty(SecondNameTextField) ||
            isTextFieldEmpty(EmailTextField) ||
            isTextFieldEmpty(PasswordTextField)
            {
            
            return "Please fill all fields"
        }
        
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Utilities.isPasswordValid(cleanedPassword) {
            //Password validation is failed
            return "Minimal length for password is 6"
        }
        
        return nil
    }
    
     
    @IBAction func signUpTap(_ sender: Any) {
        //validate fields
        let error = validateFields()
        
        if error != nil {
            
            //There was an error with the fields, show error message
            showErroMessage(error!)
        } else {
        let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let secondName = SecondNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, createUserError) in
            
            //Check if error occuired
            if createUserError != nil {
                
                //There was an error
                self.showErroMessage("Error during user creation")
                
            } else {
                
                //User was created sucessfully
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data:
                    ["firstname":firstName,
                     "secondname":secondName,
                     "uid":result!.user.uid]) { (addDocumentError) in

                        if addDocumentError != nil {
                            // Show error message
                            self.showErroMessage("User data couldn't been saving on the server")
                        }
                        
                }
                //go to home screen
                self.transitionToHome()
            }
            
        }
        }
        
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showErroMessage(_ message:String) {
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    
}


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
