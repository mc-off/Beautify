//
//  MasterCrationViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 01.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MasterCreationViewModel {
    private var isCreate    : Bool? { didSet { createClosure?() }}
    public  var messageAlert  : String? {  didSet { showAlertClosure?() }}
    
    
    
    
    var createClosure   : (()->())?
    var showAlertClosure: (()->())?
    
    
    
    
    
    
    
    func createPressed(photo: UIImage, name: String, type: String, description: String, coordinate: CLLocationCoordinate2D, fromTime: Date, toTime: Date, priceTier: Int) {
        FBMasters.shared.createMaster(photo: photo, name: name, type: type, description: description, coordinate: coordinate, fromTime: fromTime, toTime: toTime, priceTier: priceTier) {
            [unowned self] (isSuccess, error) in
            self.messageAlert = isSuccess ?  "Profile Updated Successfully" : error
        }
    }
    
    
}


