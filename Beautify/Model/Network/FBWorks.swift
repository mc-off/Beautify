//
//  FBWorks.swift
//  Beautify
//
//  Created by Артем Маков on 01.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import Firebase

class FBWorks {
    public static let shared = FBWorks()

    func loadWorks(creatorID: String, complation: @escaping([Work]?, String?)->()) {
        FBAuthentication.shared.ref.child("works").queryOrdered(byChild: "creatorID").queryEqual(toValue: creatorID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                var works = [Work]()
                let data = snapshot.children.allObjects as! [DataSnapshot]
                for workData in data {
                    var work = Work()
                    let values = workData.value as! [String: Any]
                    work.id = values["id"] as? String ?? ""
                    work.title = values["title"] as? String ?? ""
                    work.creatorID = values["creatorID"] as? String ?? ""
                    work.formID = values["formID"] as? String ?? ""
                    work.itemID = values["itemID"] as? String ?? ""
                    work.photoURL = values["photoURL"] as? String ?? ""
                                
                    works.append(work)
                }
                complation(works, nil)
            } else {
                complation(nil, "Can't load masters list")
            }
        }
    }
    
    func loadItems(complation: @escaping([Item]?, String?)->()) {
        FBAuthentication.shared.ref.child("items").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                var items = [Item]()
                let data = snapshot.children.allObjects as! [DataSnapshot]
                for itemData in data {
                    var item = Item()
                    let values = itemData.value as! [String: Any]
                    item.id = values["id"] as? String ?? ""
                    item.name = values["name"] as? String ?? ""
                    item.imageURL = values["imageURL"] as? String ?? ""
                    item.type = ItemType(rawValue: values["type"] as? String ?? "")
                    item.color = values["color"] as? String ?? ""
                                
                    items.append(item)
                }
                complation(items, nil)
            } else {
                complation(nil, "Can't load item list")
            }
        }
    }
    
    func createWork(creatorID: String, title: String, itemID: String, photoURL: String?, formID: String?, complation: @escaping(Bool, String?) -> ()) {
        let uid = Utilities.randomString(of: 28)
        let DBWork =
        ["creatorID": creatorID,
         "id": uid,
         "title": title,
         "itemID": itemID,
         "photoURL" : photoURL ?? "https://pngimg.com/uploads/nails/nails_PNG1.png",
         "formID": formID ?? "formmID"] as [String : Any]
        
        Database.database().reference().child("works").child(uid).setValue(DBWork) { (error, data) in
            if ((error) != nil) {
                complation(false, error?.localizedDescription)
            } else {
                complation(true, nil)
            }
        }
    }
}

