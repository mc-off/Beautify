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

import UIKit

class SignupViewController: UIViewController {

    private let vm    = SignupViewModel()
    private var image = UIImage() { didSet {
        profileImage.setImage(image, for: .normal) } }

    
    
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var lastTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var haveAccountButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellUI()
        initVM()
    }
    
    
    
    
    
    
    // MARK:- Init view model
    
    private func initVM() {
        vm.signupClosure = { [weak self] () in
            guard let self = self else { return }
            self.presentViewController()
        }
        
        vm.showAlertClosure = { [weak self] () in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.signUpButton.isEnabled = true
            Alert.showAlert(at: self, title: "Sign Up Validation", message: self.vm.messageAlert!)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK:- Actions
    
    private func presentViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: Identifiers.tabBar)
        loginVC.modalTransitionStyle = .crossDissolve
        self.present(loginVC, animated: true)
    }
    
    
    @IBAction func signupPressed(_ sender: UIButton) {
        dismissKeyboard()
        activityIndicator.startAnimating()
        signUpButton.isEnabled = false
        
        
        vm.signUpPressed(firstName: firstTextField.text!, lasName: lastTextfield.text!, withEmail: emailTextfield.text!, password: passwordTextfield.text!, profileImage: profileImage.currentImage!)
    }
    
    
    @IBAction func haveAccountPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func profileImagePressed(_ sender: Any) {
        SystemAuthorization.shared.photoAuthorization { [weak self] (isAuth, message) in
            guard let self = self else { return }
            if isAuth {
                self.imagePressed()
            } else {
                DispatchQueue.main.async {
                    Alert.showAlert(at: self, title: "Photo Library", message: message!)
                }
            }
        }
    }
    

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    private func setupCellUI() {
        //Setup cornerRadius
        profileImage.layer.cornerRadius = 60
        profileImage.layer.masksToBounds = true
        
        signUpButton.layer.cornerRadius = CGFloat(Constants.buttonCornerRadius)
        
        
        //Setup text fields
        firstTextField.addTopBorder()
        firstTextField.addBottomBorder()
        firstTextField.addPrefix(labelText: "Name")
        
        lastTextfield.addBottomBorder()
        lastTextfield.addPrefix(labelText: "Surname")
        
        emailTextfield.addBottomBorder()
        emailTextfield.addPrefix(labelText: "Login")
        
        passwordTextfield.addBottomBorder()
        passwordTextfield.addPrefix(labelText: "Password")
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "ToolActive")

        
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        
        activityIndicator.stopAnimating()
        
    }
}












// MARK:- Handle image picker controller

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIImagePickerController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.tintColor = UIColor.red
    }
}
