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
}
