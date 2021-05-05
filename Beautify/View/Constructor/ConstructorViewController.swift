//
//  ConstructorViewController.swift
//  Beautify
//
//  Created by Артем Маков on 10.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConstructorViewController: UITableViewController {
    
    let vm = WorksViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PreviousWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "PreviousWorkTableViewCell")
        vm.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            if self.vm.numberOfCells == 0 {
            } else {
                self.tableView.reloadData()
            }
        }
        vm.initFetch()
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "initWorkCreation", sender: self)
    }
    
}

extension ConstructorViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Прошлые работы"
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
         return 216 // custom height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfCells
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousWorkTableViewCell", for: indexPath) as! PreviousWorkTableViewCell
        cell.cellVM = vm.getCellViewModel(at: indexPath)

        return cell
    }
}
