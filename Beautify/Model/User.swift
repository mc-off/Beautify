//
//  User.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

struct User {
    var id: String?
    var email: String?
    var first: String?
    var last: String?
    var imageURL: String?
    var image: UIImage?
}





struct currentUser {
    
    static private let defualts = UserDefaults.standard
    
    static var first      : String?  { return defualts.string(forKey: "first") }
    static var last       : String?  { return defualts.string(forKey: "last") }
    static var id         : String?  { return defualts.string(forKey: "id") }
    static var email      : String?  { return defualts.string(forKey: "email") }
    static var imageURL   : String?  { return defualts.string(forKey: "imageURL") }
    static var image      : UIImage? { return UIImage(data: defualts.data(forKey: "image") ?? Data()) ?? UIImage() }
}
