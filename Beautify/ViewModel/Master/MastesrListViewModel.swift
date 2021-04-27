//
//  MastesrListViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 13.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class MasterListViewModel {
    
    var masterViewModel     = [MasterShortViewModel]() { didSet { reloadTableViewClosure?() } }
    var selectedCell        : MasterShortViewModel?
    var numberOfCells       : Int { return masterViewModel.count }
    
    var originalModel       = [MasterShortViewModel]()
    
    var reloadTableViewClosure: (()->())?
    
    
    
    
    
    
    // MARK:- Init fetch masters
    
    func initFetch() {
        FBMasters.shared.loadMasters { [weak self] (masters, error) in
            guard let self = self else { return }
            if error == nil {
                guard let masters = masters else {
                    self.reloadTableViewClosure?()
                    return
                }
                self.masterViewModel.removeAll()
                self.createMasterViewModel(masters: masters)
            }
        }
    }
    
    private func createMasterViewModel(masters: [Master]) {
        var vms = [MasterShortViewModel]()
        for master in masters {
            vms.append(proccessFetchMasters(master: master))
        }
        masterViewModel.append(contentsOf: vms)
    }
    
    private func proccessFetchMasters(master: Master) -> MasterShortViewModel {
        return MasterShortViewModel(uid: master.id!, coordinate: master.coordinate, name: master.name, profileImage: master.profileImage, type: master.type, workHours: master.workHours)
    }
    
    func getCellViewModel(at indexpath: IndexPath) -> MasterShortViewModel{
        return masterViewModel[indexpath.row]
    }
    
    func pressedCell(at indexpath: IndexPath) {
        selectedCell = masterViewModel[indexpath.row]
    }
    
    
    
    
    
    
    
    // MARK:- Handle Searching
    
    func startSearching() {
        originalModel = masterViewModel
    }
    
    func searchAbout(text: String) {
        if text.isEmpty {
            masterViewModel = originalModel
        } else {
            let text = text.lowercased()
            masterViewModel = originalModel.filter() {($0.name?.lowercased().contains((text)))!}
        }
    }
    
    func endSearching() {
        masterViewModel = originalModel
    }
    
}

struct MasterShortViewModel {
    
    var uid: String?
    var description: String?
    var coordinate: Coordinate?
    var name: String?
    var priceTier: Int?
    var profileImage: String?
    var type: String?
    var workHours: WorkHoursWeekly?
    var reviews: [String]?
}


