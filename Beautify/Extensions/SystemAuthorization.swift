//
//  SystemAutorization.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Photos
import CoreLocation

struct SystemAuthorization {
    
    static let shared = SystemAuthorization()
    
    
    
    
    
    //---------------------------------------------------------------------------------------------
    
    func photoAuthorization(complation: @escaping(Bool, String?)->()) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized:
                complation(true, nil)
            case .denied, .notDetermined, .restricted:
                PHPhotoLibrary.requestAuthorization { (isAuth) in
                    if isAuth == .authorized {
                        complation(true, nil)
                    } else {
                        complation(false, "Please go to Settings>Message now>Photos>Choose Read and Write to able access photos")
                    }
            }
            default:
                complation(false, "Please go to Settings>Message now>Photos>Choose Read and Write to able access photos")
        }
    }

}
