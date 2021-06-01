//
//  FBReview.swift
//  Beautify
//
//  Created by Артем Маков on 20.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Firebase

class FBReviews {
    public static let shared = FBReviews()
    
    func createReview(masterID: String, userID: String, description: String, grade: Double, reviewImage: UIImage, complation: @escaping(Bool, String?) -> ()) {
        let uid = Utilities.randomString(of: 28)
        guard let imageData = reviewImage.jpegData(compressionQuality: 0.5) else { return }
        let uploadTask = Storage.storage().reference().child("reviews").child("\(uid).jpg")
        uploadTask.putData(imageData, metadata: nil) { (metaData, error) in
            if error != nil {
                complation(false, error?.localizedDescription)
                return
            } else {
                uploadTask.downloadURL { [unowned self] (url, error) in
                    if error != nil {
                        uploadTask.delete(completion: nil)
                        complation(false, error?.localizedDescription)
                    } else {
                        let DBReview =
                            ["masterID": masterID,
                             "userID": userID,
                             "id": userID,
                             "username": currentUser.first!,
                             "description": description,
                             "grade": grade,
                             "topImageURL": url?.absoluteString] as [String : Any]
                        Database.database().reference().child("reviews").child(uid).setValue(DBReview) { (error, data) in
                            if error != nil {
                                complation(false, "There was a problem, Thanks to try again")
                            } else {
                                complation(true, nil)
                            }
                        }
            }
                }
            }
        }
    }
    
    func loadReviews(masterID: String, complation: @escaping([Review]?, String?)->()) {
        FBAuthentication.shared.ref.child("reviews").queryOrdered(byChild: "masterID").queryEqual(toValue: masterID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                var reviews = [Review]()
                let data = snapshot.children.allObjects as! [DataSnapshot]
                for reviewData in data {
                    var review = Review()
                    let values = reviewData.value as! [String: Any]
                    review.id = values["id"] as? String ?? ""
                    review.description = values["description"] as? String ?? ""
                    review.username = values["username"] as? String ?? "Арина"
                    review.userID = values["userID"] as? String ?? ""
                    review.masterID = values["masterID"] as? String ?? ""
                    review.topImageURL = values["topImageURL"] as? String ?? ""
                    review.grade = values["grade"] as? Double ?? 0
                    review.status = values["status"] as? String ?? "Первый раз"
                                
                    reviews.append(review)
                }
                complation(reviews, nil)
            } else {
                complation(nil, "Can't load masters list")
            }
        }
    }
    
}
