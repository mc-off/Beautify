//
//  BookingInfoViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 27.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class BookingInfoViewModel {
    
    var workViewModel = WorkViewModel() { didSet { reloadTableViewClosure?() } }
    var masterViewModel =  MasterShortViewModel() { didSet { reloadTableViewClosure?() } }
    var bookingViewModel = BookingObjectViewModel() { didSet { reloadTableViewClosure?() } }
    
    
    var numberOfCells: Int {
        return 3
    }
    
    public var message: String?         { didSet { showAlertClosure?() }}

    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure      : (()->())?
    
    
    
    // MARK:- Init fetch masters
    
    func initMasterFetch(uid: String) {
        FBMasters.shared.loadMasterInfo(for: uid) { [weak self] (master, error) in
            guard let self = self else { return }
            if error == nil {
                self.masterViewModel = self.proccessFetchMaster(master: master!)
            } else { self.message = error! }
        }
    }
    
    private func proccessFetchMaster(master: Master) -> MasterShortViewModel {
        return MasterShortViewModel(uid: master.id!, description: master.description, coordinate: master.coordinate, name: master.name, profileImage: master.profileImage, type: master.type, workHours: master.workHours, reviews: master.reviews)
    }
    
    func initWorkFetch(uid: String) {
        FBWorks.shared.loadWork(id: uid) { [weak self] (work, error) in
            guard let self = self else { return }
            if error == nil {
                self.workViewModel = self.proccessFetchWork(work: work!)
            } else { self.message = error! }
        }
    }
    
    
    private func proccessFetchWork(work: Work) -> WorkViewModel {
        return WorkViewModel(id: work.id!, title: work.title, creatorID: work.creatorID, formID: work.formID, itemID: work.itemID, photoURL: work.photoURL)
    }
    
}
