//
//  BookingViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 15.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class BookingViewModel {
    private var isCreate    : Bool? { didSet { createClosure?() }}
    public  var messageAlert  : String? {  didSet { showAlertClosure?() }}
    
    
    var userWorksViewModel = WorksViewModel()
    var masterWorksViewModel = WorksViewModel()
    var selectedCell        : WorkViewModel?
    
    
    
    
    
    var createClosure   : (()->())?
    var showAlertClosure: (()->())?
    var reloadTableViewClosure: (()->())?
    
    
    
    
    
    
    
    func createPressed(masterID: String, bookDate: Date) {
        FBMasters.shared.createBooking(masterID: masterID, userID: currentUser.id!, bookDate: bookDate, workID: selectedCell!.id!) {
            [unowned self] (isSuccess, error) in
            self.messageAlert = isSuccess ?  "Booking created successfully" : error
        }
    }
    
    
}
