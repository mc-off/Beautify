//
//  FBDDatabase.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import Firebase

struct FBDatabase {
    
    
    static let shared = FBDatabase()
    
    
    
    
    // MARK:- User database
    
    func loadUserInfo(for uid: String, complation: @escaping(User?, String?)->()) {
        FBAuthentication.shared.ref.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                let values = snapshot.value as! [String: Any]
                var user = User()
                user.email = values["email"] as? String ?? ""
                user.id = values["id"] as? String ?? ""
                user.first = values["first"] as? String ?? ""
                user.last = values["last"] as? String ?? ""
                user.imageURL = values["imageULR"] as? String ?? ""
                complation(user, nil)
            } else {
                complation(nil, "The user is not exist")
            }
        }
    }

}
