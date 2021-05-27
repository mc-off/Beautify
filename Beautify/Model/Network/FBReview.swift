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
                    review.username = "Алина"
                    review.userID = values["userID"] as? String ?? ""
                    review.masterID = values["masterID"] as? String ?? ""
                    review.topImageURL = values["topImageURL"] as? String ?? ""
                    review.grade = values["topImageURL"] as? Int ?? 0
                                
                    reviews.append(review)
                }
                complation(reviews, nil)
            } else {
                complation(nil, "Can't load masters list")
            }
        }
    }
    
}
