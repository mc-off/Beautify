//
//  FBAuth.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import Firebase

class FBAuthentication {
    
    public static let shared = FBAuthentication()
    
    public let ref = Database.database().reference()
    
    
    
    
    
    
    
    //MARK:- User authentications
    
    func FBSignInUser(withEmail email: String, password: String, complation: @escaping(Bool, String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                complation(false, error?.localizedDescription)
            } else {
                guard let user = result?.user else {
                    complation(false, "There was a problem, Thanks to try again")
                    return
                }
                FBDatabase.shared.loadUserInfo(for: user.uid) { (user, error) in
                    guard let user = user else { return }
                    DefaultSettings.shared.setUserDefauls(first: user.first, last: user.last, id: user.id, email: user.email, imageURL: user.imageURL)
                    complation(true, nil)
                }
            }
        }
    }
    
    
    
    
    func FBSignUpUser(firstName: String, lasName: String, withEmail email: String, password: String, profileImage: UIImage?, complation: @escaping(Bool, String?) -> ()) {
        
        //Validate TextFields isValid or Not
        guard !firstName.isEmpty && !lasName.isEmpty && !email.isEmpty && !password.isEmpty  else {
            complation(false, "Please enter all required fields")
            return
        }
        
        //Create and Insert user info to DBfirebase
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (result, error) in
            if error != nil {
                complation(false, error?.localizedDescription)
            } else {
                guard let FBUser = result?.user else {
                    complation(false, "There was a problem, Thanks to try again")
                    return
                }
                        guard let imageData = profileImage?.jpegData(compressionQuality: 0.5) else { return }
                        let uploadTask = Storage.storage().reference().child("profile").child("\(FBUser.uid).jpg")
                        uploadTask.putData(imageData, metadata: nil) { (metaData, error) in
                            if error != nil {
                                FBUser.delete()
                                complation(false, error?.localizedDescription)
                                return
                            } else {
                                uploadTask.downloadURL { [unowned self] (url, error) in
                                    if error != nil {
                                        uploadTask.delete(completion: nil)
                                        FBUser.delete()
                                        complation(false, error?.localizedDescription)
                                    } else {
                                        let DBUser =
                                            ["first": firstName,
                                             "last": lasName,
                                             "email": email,
                                             "id": FBUser.uid,
                                             "imageULR": url?.absoluteString]
                                        self.ref.child("users").child(FBUser.uid).setValue(DBUser) { (error, data) in
                                            if error != nil {
                                                FBUser.delete()
                                                complation(false, "There was a problem, Thanks to try again")
                                            } else {
                                                DefaultSettings.shared.setUserDefauls(first: firstName, last: lasName, id: FBUser.uid, email: email, imageURL: url!.absoluteString)
                                                complation(true, nil)
                                            }
                                        }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func signOutUser(complation: @escaping(Bool, String?) -> ()) {
        do {
            try Auth.auth().signOut()
            complation(true, nil)
        } catch {
            complation(false, error.localizedDescription)
        }
    }
    
    
    
    func resetPassword(email: String, complation: @escaping(Bool, String?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            error == nil ? complation(true, nil) : complation(false, error?.localizedDescription) }
    }
    
    func changePassword(password: String, complation: @escaping(Bool, String?) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            error == nil ? complation(true, nil) : complation(false, error?.localizedDescription) })
    }
}
