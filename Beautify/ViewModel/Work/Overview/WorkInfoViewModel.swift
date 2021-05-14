//
//  WorksViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 13.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class WorkInfoViewModel {
    
    var workViewModel = WorkViewModel() { didSet { reloadTableViewClosure?() } }
    var itemViewModel = ItemViewModel() { didSet { reloadTableViewClosure?() } }
        
    var reloadTableViewClosure: (()->())?
    
    
    // MARK:- Init fetch masters
    
    func initWorkFetch(workID: String) {
        FBWorks.shared.loadWork(id: workID) { [weak self] (work, error) in
            guard let self = self else { return }
            if error == nil {
                guard let work = work else {
                    self.reloadTableViewClosure?()
                    return
                }
                self.createWorkViewModel(work: work)
            }
        }
    }
    
    func initItemFetch(itemID: String) {
        FBWorks.shared.loadItem(id: itemID) { [weak self] (item, error) in
            guard let self = self else { return }
            if error == nil {
                guard let item = item else {
                    self.reloadTableViewClosure?()
                    return
                }
                self.createItemViewModel(item: item)
            }
        }
    }
    
    private func createWorkViewModel(work: Work) {
        workViewModel = proccessFetchWorks(work: work)
    }
    
    private func proccessFetchWorks(work: Work) -> WorkViewModel {
        return WorkViewModel(id: work.id!, title: work.title, creatorID: work.creatorID, formID: work.formID, itemID: work.itemID, photoURL: work.photoURL)
    }
    
    private func createItemViewModel(item: Item) {
        itemViewModel = proccessFetchItems(item: item)
    }
    
    private func proccessFetchItems(item: Item) -> ItemViewModel {
        return ItemViewModel(id: item.id!, color: item.color, imageURL: item.imageURL, name: item.name, type: item.type)
    }
    
    
    // MARK:- Handle Searching
    
}
