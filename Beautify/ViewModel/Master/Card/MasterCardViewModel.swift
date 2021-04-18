//
//  MasterCardViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 19.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class MasterCardViewModel {
    
    var masterViewModel     =  MasterShortViewModel() { didSet { reloadTableViewClosure?() } }
    var selectedCell        : MasterShortViewModel?
//    var numberOfCells       : Int { return masterViewModel.count }
    
    public var message: String?         { didSet { showAlertClosure?() }}

    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure      : (()->())?
    
    
    
    
    
    
    // MARK:- Init fetch masters
    
    func initFetch(uid: String) {
        FBMasters.shared.loadMasterInfo(for: uid) { [weak self] (master, error) in
            guard let self = self else { return }
            if error == nil {
                self.masterViewModel = self.proccessFetchMaster(master: master!)
            } else { self.message = error! }
        }
    }
    
    private func proccessFetchMaster(master: Master) -> MasterShortViewModel {
        return MasterShortViewModel(uid: master.id!, description: master.description, coordinate: master.coordinate, name: master.name, profileImage: master.profileImage, type: master.type, workHours: master.workHours)
    }
    
    
    
}
