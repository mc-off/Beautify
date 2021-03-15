//
//  FBDDatabase.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import MapKit

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
    
    
    
    func editeProfile(profileImage: UIImage, firstName: String?, lastName: String?, complation: @escaping(Bool, String?) -> ()) {
        let uid = Auth.auth().currentUser?.uid
        guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
        let uploadTask = Storage.storage().reference().child("profile").child("\(uid!).jpg")
        uploadTask.putData(imageData, metadata: nil) { (metadat, error) in
            if error == nil {
                uploadTask.downloadURL { (url, error) in
                    if error == nil {
                        Database.database().reference().child("users").child(uid!).updateChildValues(
                            ["imageULR": url!.absoluteString,
                             "first":firstName ?? UserDefaults.standard.data(forKey: "first")!,
                             "last":lastName ?? UserDefaults.standard.data(forKey: "last")!
                        ]) { (error, data) in
                            let Url = URL(string: url!.absoluteString)
                            let data = try? Data(contentsOf: Url!)
                            UserDefaults.standard.set(url?.absoluteString, forKey: "imageURL")
                            UserDefaults.standard.set(data, forKey: "image")
                            if (firstName != nil) {
                                UserDefaults.standard.set(firstName, forKey: "first")
                            }
                            if (lastName != nil) {
                                UserDefaults.standard.set(lastName, forKey: "last")
                            }
                            complation(true, nil)
                        }
                    } else {
                        uploadTask.delete(completion: nil)
                        complation(false, "Sorry, There is a problem. Try again")
                    }
                }
            } else {
                complation(false, "Sorry, There is a problem. Try again")
            }
        }
    }
    
    
    func createMaster(photo: UIImage, name: String, type: String, description: String, coordinate: CLLocationCoordinate2D, fromTime: Date, toTime: Date, priceTier: Int, complation: @escaping(Bool, String?) -> ()) {
        let uid = Utilities.randomString(of: 28)
        print(uid)
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
        let uploadTask = Storage.storage().reference().child("masters").child("\(uid).jpg")
        uploadTask.putData(imageData, metadata: nil) { (metadat, error) in
            if error == nil {
                print("photo success")
                uploadTask.downloadURL { (url, error) in
                    if error == nil {
                        let DBMaster =
                        ["name": name,
                         "type": type,
                         "description": description,
                         "profileImage" : url!.absoluteString,
                         "coordinate": [
                            "longitude" : coordinate.longitude,
                            "latitude" : coordinate.latitude
                            ],
                         "priceTier": priceTier,
                         "workHours": [
                            "everyday" : [
                                "from" : ISO8601DateFormatter().string(from: fromTime),
                                "to" : ISO8601DateFormatter().string(from: toTime)
                            ]
                            ]
                            ] as [String : Any]
                        
                        Database.database().reference().child("masters").child(uid).setValue(DBMaster) { (error, data) in
                            complation(true, nil)
                        }
                    } else {
                        uploadTask.delete(completion: nil)
                        print("Fail on master upload")
                        complation(false, "Sorry, There is a problem. Try again")
                    }
                }
            } else {
                print("Fail on photo master upload")
                complation(false, "Sorry, There is a problem. Try again")
            }
        }
    }
    
    
    

}
