//
//  BookingsViewController.swift
//  Beautify
//
//  Created by Артем Маков on 27.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

//
//  MasterCreationViewController.swift
//  Beautify
//
//  Created by Артем Маков on 01.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class BookingsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let vm = BookingListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "BookingTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingTableViewCell")
        initVM()
    }
    
    
    private func initVM() {
        vm.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            if self.vm.numberOfCells == 0 {
                self.tableView.alpha = 0
            } else {
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.2) {
                    self.tableView.alpha = 1
                }
            }
        }
        vm.initFetch()
    }
    
}

extension BookingsListViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Прошлые заказы"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell

        cell.cellVM = vm.getCellViewModel(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.pressedCell(at: indexPath)
        performSegue(withIdentifier: "bookingInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookingInfo" {
            let vc = segue.destination as! BookingInfoViewController
            vc.masterID = vm.selectedCell!.masterID!
            vc.bookingVM = vm.selectedCell!
        }
    }
    
}
