//
//  Deffaults.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

struct DefaultSettings {
    
    static let shared   = DefaultSettings()
    public let defaults = UserDefaults.standard
    
    func initUserDefaults(completion: @escaping (User)->()) {
        var user = User()
        user.first = defaults.string(forKey: "first")
        user.last = defaults.string(forKey: "last")
        user.id = defaults.string(forKey: "id")
        user.email = defaults.string(forKey: "email")
        user.imageURL = defaults.string(forKey: "imageURL")
        user.image = UIImage(data: defaults.data(forKey: "image")!)
        completion(user)
    }
    
    func setUserDefauls(first: String?, last: String?, id: String?, email: String?, imageURL: String?) {
        
        self.defaults.set(first, forKey: "first")
        self.defaults.set(last, forKey: "last")
        self.defaults.set(id, forKey: "id")
        self.defaults.set(email, forKey: "email")
        self.defaults.set(imageURL, forKey: "imageURL")
        
        guard let imageURL = imageURL else { return }
        let Url = URL(string: imageURL)
        let data = try? Data(contentsOf: Url!)
        self.defaults.set(data, forKey: "image")
    }
}
