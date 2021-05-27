//
//  BookingViewController.swift
//  Beautify
//
//  Created by Артем Маков on 15.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController, WorkTappedDelegate {
    
    func didTapWork(workVM: WorkViewModel) {
        vm.selectedCell = workVM
    }
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var vm = BookingViewModel()

    

    var uid = String()
    var minimumDate = Date()
    var maximumDate = Date()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BookingWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingWorkTableViewCell")
        
        timePicker.minimumDate = minimumDate
        
        vm.showAlertClosure = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
            Alert.showAlert(at: self, title: "", message: self.vm.messageAlert!)
        }
        
        initVM()
    }
    
    private func initVM() {
        vm.userWorksViewModel.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            if self.vm.userWorksViewModel.numberOfCells == 0 {
            } else {
                self.tableView.reloadData()
            }
        }
        vm.userWorksViewModel.initFetch()
        vm.masterWorksViewModel.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            if self.vm.userWorksViewModel.numberOfCells == 0 {
            } else {
                self.tableView.reloadData()
            }
        }
        vm.masterWorksViewModel.initFetch(creatorID: uid)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        vm.createPressed(masterID: uid, bookDate: timePicker.date)
    }
    

}

extension BookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if ((vm.userWorksViewModel.numberOfCells != 0) && (vm.masterWorksViewModel.numberOfCells != 0)) {
            return 2
        } else if ((vm.userWorksViewModel.numberOfCells != 0) || (vm.masterWorksViewModel.numberOfCells != 0)) {
            return 1
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if (vm.masterWorksViewModel.numberOfCells != 0) {
                return "Работы мастерской"
            } else {
                return "Мои работы"
            }
        default:
            return "Мои работы"
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
         return 216 // custom height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if (vm.masterWorksViewModel.numberOfCells != 0) {
                return vm.masterWorksViewModel.numberOfCells
            } else {
                return vm.userWorksViewModel.numberOfCells
            }
        case 1:
            return vm.userWorksViewModel.numberOfCells
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if (vm.masterWorksViewModel.numberOfCells != 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BookingWorkTableViewCell", for: indexPath) as! BookingWorkTableViewCell
                cell.cellVM = vm.masterWorksViewModel.getCellViewModel(at: indexPath)
                cell.delegate = self

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BookingWorkTableViewCell", for: indexPath) as! BookingWorkTableViewCell
                cell.cellVM = vm.userWorksViewModel.getCellViewModel(at: indexPath)
                cell.delegate = self


                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingWorkTableViewCell", for: indexPath) as! BookingWorkTableViewCell
            cell.cellVM = vm.userWorksViewModel.getCellViewModel(at: indexPath)
            cell.delegate = self

            return cell
        }
    }
    
}
