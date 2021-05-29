//
//  ReviewViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 06.06.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class ReviewCreationViewModel {
    private var isCreate    : Bool? { didSet { createClosure?() }}
    public  var messageAlert  : String? {  didSet { showAlertClosure?() }}
    
    
    
    
    var createClosure   : (()->())?
    var showAlertClosure: (()->())?
    
    
    
    
    
    
    
    func createPressed(masterID: String, userID: String, description: String, grade: Double, reviewImage: UIImage) {
        FBReviews.shared.createReview(masterID: masterID, userID: userID, description: description, grade: grade, reviewImage: reviewImage) {
            [unowned self] (isSuccess, error) in
            self.messageAlert = isSuccess ?  "Отзыв успешно создан" : error
        }
    }
    
    
}
