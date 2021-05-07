//
//  FinallTableViewController.swift
//  Beautify
//
//  Created by Артем Маков on 07.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class FinallTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FinalInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "FinalInformationTableViewCell")
        tableView.register(UINib(nibName: "FinalItemTableViewCell", bundle: nil), forCellReuseIdentifier: "FinalItemTableViewCell")
        tableView.register(UINib(nibName: "ARTableViewCell", bundle: nil), forCellReuseIdentifier: "ARTableViewCell")
        
        tableView.backgroundColor = UIColor.systemGroupedBackground

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 64
        case 1:
            return 224
        default:
            return 80
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "FinalInformationTableViewCell", for: indexPath) as! FinalInformationTableViewCell
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "FinalItemTableViewCell", for: indexPath) as! FinalItemTableViewCell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "ARTableViewCell", for: indexPath) as! ARTableViewCell
        }
       
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Information"
        case 1:
            return "Item"
        default:
            return nil
        }
        
    }

}
