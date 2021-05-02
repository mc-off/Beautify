//
//  WorksViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 01.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class WorksViewModel {
    
    var worksViewModel     = [WorkViewModel]() { didSet { reloadTableViewClosure?() } }
    var selectedCell        : WorkViewModel?
    var numberOfCells       : Int { return worksViewModel.count }
        
    var reloadTableViewClosure: (()->())?
    
    
    
    
    
    
    // MARK:- Init fetch masters
    
    func initFetch() {
        FBWorks.shared.loadWorks(creatorID: currentUser.id!) { [weak self] (works, error) in
            guard let self = self else { return }
            if error == nil {
                guard let works = works else {
                    self.reloadTableViewClosure?()
                    return
                }
                self.worksViewModel.removeAll()
                self.createWorksViewModel(works: works)
            }
        }
    }
    
    private func createWorksViewModel(works: [Work]) {
        var vms = [WorkViewModel]()
        for work in works {
            vms.append(proccessFetchWorks(work: work))
        }
        worksViewModel.append(contentsOf: vms)
    }
    
    private func proccessFetchWorks(work: Work) -> WorkViewModel {
        return WorkViewModel(id: work.id!, creatorID: work.creatorID, formID: work.formID, itemID: work.itemID, photoURL: work.photoURL)
    }
    
    func getCellViewModel(at indexpath: IndexPath) -> WorkViewModel{
        return worksViewModel[indexpath.row]
    }
    
    func pressedCell(at indexpath: IndexPath) {
        selectedCell = worksViewModel[indexpath.row]
    }
    
    
    // MARK:- Handle Searching
    
}

struct WorkViewModel {
    
    var id: String?
    var title: String?
    var creatorID: String?
    var formID: String?
    var itemID: String?
    var photoURL: String?
}


