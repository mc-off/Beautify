//
//  MasterCrationViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 01.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class MasterCreationViewModel {
    private var isCreate    : Bool? { didSet { createClosure?() }}
    public  var messageAlert  : String? {  didSet { showAlertClosure?() }}
    
    
    
    
    var createClosure   : (()->())?
    var showAlertClosure: (()->())?
    
    
    
    
    
    
    
    func createPressed(name: String, type: String, description: String, longtitude: Int, latitude: Int) {
        //
    }
}
