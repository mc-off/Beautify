//
//  FBMasters.swift
//  Beautify
//
//  Created by Артем Маков on 01.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import MapKit
import GoogleMaps


class FBMasters {
    
    public static let shared = FBMasters()
    let dateFormatter = ISO8601DateFormatter()


    
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
                         "id": uid,
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
    
    func loadMasters(complation: @escaping([Master]?, String?)->()) {
        FBAuthentication.shared.ref.child("masters").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                var masters = [Master]()
                let data = snapshot.children.allObjects as! [DataSnapshot]
                for master in data {
                    var masterModel = Master()
                    let id = master.childSnapshot(forPath: "id").value as? String
                    if (id=="") {}
                    else {
                        masterModel.id = id
                        
                        masterModel.name = master.childSnapshot(forPath: "name").value as? String
                        let latitude = master.childSnapshot(forPath: "coordinate").childSnapshot(forPath: "latitude").value as? Double
                        let longitude = master.childSnapshot(forPath: "coordinate").childSnapshot(forPath: "longitude").value as? Double
                        masterModel.coordinate = Coordinate(longitude: longitude!, latitude: latitude!)
                        
                        masterModel.priceTier = master.childSnapshot(forPath: "priceTier").value as? Int
                        masterModel.grade = master.childSnapshot(forPath: "grade").value as? Double
                        masterModel.gradeAmount = master.childSnapshot(forPath: "gradeAmount").value as? Int
                        masterModel.profileImage = master.childSnapshot(forPath: "profileImage").value as? String
                        masterModel.description = master.childSnapshot(forPath: "description").value as? String
                        masterModel.type = master.childSnapshot(forPath: "type").value as? String
                        
                        let fromDate = self.dateFormatter.date(from: master.childSnapshot(forPath: "workHours").childSnapshot(forPath: "everyday").childSnapshot(forPath: "from").value as! String)
                        
                        let toDate = self.dateFormatter.date(from: master.childSnapshot(forPath: "workHours").childSnapshot(forPath: "everyday").childSnapshot(forPath: "to").value as! String)
                        
                        masterModel.workHours = WorkHoursWeekly(everyday: WorkHours(
                                                                    from:  fromDate!,
                                                                    to: toDate!
                                                                    ))
                        masters.append(masterModel)

                    }
                }
                complation(masters, nil)
            } else {
                complation(nil, "Can't load masters list")
            }
        }
    }
    
    func loadMasterInfo(for uid: String, complation: @escaping(Master?, String?)->()) {
        FBAuthentication.shared.ref.child("masters").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                let values = snapshot.value as! [String: Any]
                var master = Master()
                master.id = values["id"] as? String ?? ""
                master.name = values["name"] as? String ?? ""
                master.description = values["description"] as? String ?? ""
                master.type = values["type"] as? String ?? ""
                master.grade = values["grade"] as? Double ?? 0
                master.gradeAmount = values["gradeAmount"] as? Int ?? 0
                master.priceTier = snapshot.childSnapshot(forPath: "priceTier").value as? Int
                master.profileImage = values["profileImage"] as? String ?? ""
                let latitude = snapshot.childSnapshot(forPath: "coordinate").childSnapshot(forPath: "latitude").value as? Double
                let longitude = snapshot.childSnapshot(forPath: "coordinate").childSnapshot(forPath: "longitude").value as? Double
                master.coordinate = Coordinate(longitude: longitude!, latitude: latitude!)
                
                let reviews = snapshot.childSnapshot(forPath: "reviews").value as? [String:AnyObject]
                
                master.reviews = [String]()
                
                if reviews != nil {
                    for (review,_) in reviews! {
                        master.reviews!.append(review)
                    }
                }
                
                master.contacts = []
                
                let contactsData = snapshot.childSnapshot(forPath: "contacts").children.allObjects as! [DataSnapshot]
                
                for contactData in contactsData {
                    let contactValues = contactData.value as! [String: Any]
                    var contact = Contact()
                    
                    contact.value = contactValues["value"] as? String ?? ""
                    contact.type = ContactType(rawValue: contactValues["type"] as? String ?? "")
                    
                    master.contacts?.append(contact)
                }
                
                master.reviews = [String]()
                
                if reviews != nil {
                    for (review,_) in reviews! {
                        master.reviews!.append(review)
                    }
                }
                                                
                let fromDate = self.dateFormatter.date(from: snapshot.childSnapshot(forPath: "workHours").childSnapshot(forPath: "everyday").childSnapshot(forPath: "from").value as! String)
                
                let toDate = self.dateFormatter.date(from: snapshot.childSnapshot(forPath: "workHours").childSnapshot(forPath: "everyday").childSnapshot(forPath: "to").value as! String)
                
                master.workHours = WorkHoursWeekly(everyday: WorkHours(
                                                            from:  fromDate!,
                                                            to: toDate!
                                                            ))
                
                complation(master, nil)
            } else {
                complation(nil, "The master is not exist")
            }
        }
    }
    
    func createBooking(masterID: String, userID: String, bookDate: Date, workID: String, complation: @escaping(Bool, String?) -> ()) {
        let uid = Utilities.randomString(of: 28)
        let DBBooking =
        ["id": uid,
         "masterID": masterID,
         "userID": userID,
         "workID": workID,
         "bookDate": ISO8601DateFormatter().string(from: bookDate)] as [String : Any]
         
        
        Database.database().reference().child("bookings").child(uid).setValue(DBBooking) { (error, data) in
            if ((error) != nil) {
                complation(false, error?.localizedDescription)
            } else {
                complation(true, nil)
            }
        }
    }
    
    func loadBookings(userID: String,  complation: @escaping([Booking]?, String?) -> ()) {
        FBAuthentication.shared.ref.child("bookings").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                var bookings = [Booking]()
                let data = snapshot.children.allObjects as! [DataSnapshot]
                for bookingData in data {
                    var book = Booking()
                    let values = bookingData.value as! [String: Any]
                    book.id = values["id"] as? String ?? ""
                    book.masterID = values["masterID"] as? String ?? ""
                    book.workID = values["workID"] as? String ?? ""
                    book.userID = values["userID"] as? String ?? ""
                    book.bookDate = self.dateFormatter.date(from: values["bookDate"] as! String)

                    bookings.append(book)
                }
                bookings.sort(by: {$0.bookDate! > $1.bookDate!})
                complation(bookings, nil)
            } else {
                complation(nil, "Can't load bookings list")
            }
        }
    }
}
