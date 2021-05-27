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
    }
    
    private func initVM() {
        vm.reloadTableViewClosure = { [unowned self] in
            self.tableView.reloadData()
        }
        vm.bookingViewModel = bookingVM!
        vm.initMasterFetch(uid: masterID!)
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
       return 2
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
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "masterInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "masterInfo" {
            let vc = segue.destination as! MasterCardViewController
            vc.masterTitle = vm.masterViewModel.name!
            vc.masterType = vm.masterViewModel.type!
            vc.uid  = vm.masterViewModel.uid!
        }
    }

}
