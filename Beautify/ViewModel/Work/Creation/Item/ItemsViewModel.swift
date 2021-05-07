//
//  WorksViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 01.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class ItemsViewModel {
    
    var mattItemsViewModel     = [ItemViewModel]() { didSet { reloadTableViewClosure?() } }
    var glossyItemsViewModel     = [ItemViewModel]() { didSet { reloadTableViewClosure?() } }

    var selectedCell: ItemViewModel?
    var numberOfMattCells       : Int { return mattItemsViewModel.count }
    var numberOfGloccyCells       : Int { return glossyItemsViewModel.count }

        
    var reloadTableViewClosure: (()->())?
    
    
    
    
    
    
    // MARK:- Init fetch masters
    
    func initFetch() {
        FBWorks.shared.loadItems() { [weak self] (items, error) in
            guard let self = self else { return }
            if error == nil {
                guard let items = items else {
                    self.reloadTableViewClosure?()
                    return
                }
                self.mattItemsViewModel.removeAll()
                self.glossyItemsViewModel.removeAll()
                self.createItemsViewModel(items: items)
            }
        }
    }

    
    private func createItemsViewModel(items: [Item]) {
        var gloccyVms = [ItemViewModel]()
        var mattVms = [ItemViewModel]()
        for item in items {
            if (item.type==ItemType.glossy) {
                gloccyVms.append(proccessFetchItem(item: item))
            } else {
                mattVms.append(proccessFetchItem(item: item))
            }
        }
        mattItemsViewModel.append(contentsOf: mattVms)
        glossyItemsViewModel.append(contentsOf: gloccyVms)
    }
    
    private func proccessFetchItem(item: Item) -> ItemViewModel {
        return ItemViewModel(id: item.id!, color: item.color, imageURL: item.imageURL, name: item.name, type: item.type)
    }
    
    func getGloccyCellViewModel(at indexpath: Int) -> ItemViewModel{
        return glossyItemsViewModel[indexpath]
    }
    
    func getMattCellViewModel(at indexpath: Int) -> ItemViewModel{
        return mattItemsViewModel[indexpath]
    }
    
    func pressedGlocyCell(at indexpath: IndexPath) {
        selectedCell = glossyItemsViewModel[indexpath.row]
    }
    
    func pressedMattCell(at indexpath: IndexPath) {
        selectedCell = mattItemsViewModel[indexpath.row]
    }
    
    
    // MARK:- Handle Searching
    
}

struct ItemViewModel {
    
    var id: String?
    var color: String?
    var imageURL: String?
    var name: String?
    var type: ItemType?
}


