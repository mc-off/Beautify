//
//  WorkInfoTableViewController.swift
//  Beautify
//
//  Created by Артем Маков on 12.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class WorkInfoTableViewController: UITableViewController, ARButtonDelegate {
    
    func buttonTapped() {
        let vc = ARViewController()
        let color = UIColor(hex: vm.itemViewModel.color!.uppercased())
        vc.selectedColor = color
        vc.hidesBottomBarWhenPushed = true

        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var workTitle: String?
    
    var itemID: String?
    
    var vm = WorkInfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = workTitle
        
        tableView.register(UINib(nibName: "FinalItemTableViewCell", bundle: nil), forCellReuseIdentifier: "FinalItemTableViewCell")
        tableView.register(UINib(nibName: "ARTableViewCell", bundle: nil), forCellReuseIdentifier: "ARTableViewCell")
        
        tableView.backgroundColor = UIColor.systemGroupedBackground
        
        vm.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            if (self.vm.itemViewModel.id==nil) {
            } else {
                self.tableView.reloadData()
            }
        }
        vm.initItemFetch(itemID: itemID!)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch vm.itemViewModel.id==nil {
        case true:
            return 0
        default:
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 224
        default:
            return 80
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch vm.itemViewModel.id==nil {
        case true:
            return 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinalItemTableViewCell", for: indexPath) as! FinalItemTableViewCell
            cell.cellVM = vm.itemViewModel
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ARTableViewCell", for: indexPath) as! ARTableViewCell
            cell.delegate = self
            return cell
        }
       
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Элемент"
        default:
            return nil
        }
    }
    
    

}
