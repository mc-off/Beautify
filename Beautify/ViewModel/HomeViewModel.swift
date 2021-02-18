//
//  HomeViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import Firebase


class HomeViewModel {
    
    let defaults = UserDefaults.standard
    var user = User() {
        didSet {
            loadInfoClosure?()
        }
    }
    
    var loadInfoClosure: (()->())?
    
    
    func loadInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if self.defaults.string(forKey: "id") == uid  {
            DefaultSettings.shared.initUserDefaults { (user) in
                self.user = user
            }
        } else {
        FBDatabase.shared.loadUserInfo(for: uid) { [weak self] (user, error) in
                guard let self = self else { return }
                if error != nil {
                    print(error!)
                } else {
                    guard let user = user else { return }
                    self.user = user
                    DefaultSettings.shared.setUserDefauls(first: user.first, last: user.last, id: user.id, email: user.email, imageURL: user.imageURL)
                }
            }
        }
    }
}
