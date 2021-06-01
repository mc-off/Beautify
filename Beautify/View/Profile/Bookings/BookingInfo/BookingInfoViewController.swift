//
//  BookingInfoViewController.swift
//  Beautify
//
//  Created by Артем Маков on 27.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class BookingInfoViewController: UIViewController {
    
    public var bookingVM: BookingObjectViewModel?
    public var workID: String?
    public var masterID: String?


    @IBOutlet weak var tableView: UITableView!
    
    private let vm = BookingInfoViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    
    private func initView() {
        tableView.register(UINib(nibName: "BookingInfoTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingInfoTimeTableViewCell")
        tableView.register(UINib(nibName: "BookingInfoMasterTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingInfoMasterTableViewCell")
        tableView.register(UINib(nibName: "PreviousWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "PreviousWorkTableViewCell")
        
    }
    
    private func initVM() {
        vm.reloadTableViewClosure = { [unowned self] in
            self.tableView.reloadData()
        }
        vm.bookingViewModel = bookingVM!
        vm.initMasterFetch(uid: masterID!)
        vm.initWorkFetch(uid: workID ?? "")
    }
    
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "reviewCreation", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BookingInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if (workID == nil) {
            return 2
        } else {
            return 3
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            case 0:
                return "Мастерская"
            case 1:
                return "Время"
            case 2:
                return "Работа"
            default:
                return nil
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingInfoTimeTableViewCell",
            for: indexPath) as? BookingInfoTimeTableViewCell
            cell?.cellVM = vm.bookingViewModel
            
            return cell ?? UITableViewCell()
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingInfoMasterTableViewCell",
            for: indexPath) as? BookingInfoMasterTableViewCell
            cell?.cellVM = vm.masterViewModel
            
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousWorkTableViewCell",
            for: indexPath) as? PreviousWorkTableViewCell
            cell?.cellVM = vm.workViewModel
            
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "masterInfo", sender: self)
        case 2:
            performSegue(withIdentifier: "workInfo", sender: self)
        default:
            print("Tapped extra row")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "masterInfo":
            let vc = segue.destination as! MasterCardViewController
            vc.masterTitle = vm.masterViewModel.name!
            vc.masterType = vm.masterViewModel.type!
            vc.uid  = vm.masterViewModel.uid!
            vc.priceSegmentValue = vm.masterViewModel.priceTier!
            vc.grade = vm.masterViewModel.grade
            vc.gradeAmount = vm.masterViewModel.gradeAmount
        case "reviewCreation":
            let vc = segue.destination as! ReviewCreationViewController
            vc.masterID = vm.masterViewModel.uid!
        default:
            let vc = segue.destination as! WorkInfoTableViewController
            vc.itemID = vm.workViewModel.itemID!
            vc.workTitle = vm.workViewModel.title
        }
    }

}
