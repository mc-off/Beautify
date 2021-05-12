//
//  MasterCrationViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 11.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class WorkCreationViewModel {
    private var isCreate    : Bool? { didSet { createClosure?() }}
    public  var messageAlert  : String? {  didSet { showAlertClosure?() }}
    
    
    
    
    var createClosure   : (()->())?
    var showAlertClosure: (()->())?
    
    
    
    func createPressed(title: String, itemID: String) {
        FBWorks.shared.createWork(creatorID: currentUser.id!, title: title, itemID: itemID, photoURL: nil, formID: nil) {
            [unowned self] (isSuccess, error) in
            self.messageAlert = isSuccess ?  "Work created successfully" : error
        }
    }
    
    
}


