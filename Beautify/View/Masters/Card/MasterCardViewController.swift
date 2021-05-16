//
//  MasterCardViewController.swift
//  Beautify
//
//  Created by Артем Маков on 11.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class MasterCardViewController: UIViewController {
    
    public var masterTitle: String?
    public var masterType: String?
    public var uid : String?

    @IBOutlet weak var headTitleLabel: UILabel!
    @IBOutlet weak var headTypeLabel: UILabel!
    @IBOutlet weak var headSegmentedControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    
    private let vm = MasterCardViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headTitleLabel.text = masterTitle
        headTypeLabel.text = masterType
        
        headSegmentedControl.superview?.clipsToBounds = true
        
        tableView.contentInsetAdjustmentBehavior = .automatic

        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: CGFloat.leastNormalMagnitude)))

        
        tableView.register(UINib(nibName: "MasterCardDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardDescriptionTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardWorkingHoursTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardWorkingHoursTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardContactsTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardPriceListTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardPriceListTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardReviewTableViewCell")
        
        tableView.register(UINib(nibName: "PreviousWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "PreviousWorkTableViewCell")
        // Do any additional setup after loading the view.
        
        vm.reloadTableViewClosure = { [unowned self] in
            self.tableView.reloadData()
        }
        vm.initFetch(uid: uid!)
    }
    
    @IBAction func headSegmentedControlValueChanged(_ sender: Any) {
        vm.selectedSegment = headSegmentedControl.selectedSegmentIndex
        vm.reloadTableViewClosure?()
    }
    
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "booking", sender: self)
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

extension MasterCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch headSegmentedControl.selectedSegmentIndex {
        case 0:
            return 4
        default:
            return 1
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (headSegmentedControl.selectedSegmentIndex == 0) {
            switch section {
            case 0:
                return "Overview"
            case 1:
                return "Contacts"
            case 2:
                return "Working time"
            case 3:
                return "Price list"
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (headSegmentedControl.selectedSegmentIndex == 0) {
            return 30
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch headSegmentedControl.selectedSegmentIndex {
        case 0:
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            default:
                return 1
            }
        default:
            return vm.numberOfCells
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch headSegmentedControl.selectedSegmentIndex {
        case 0:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCardDescriptionTableViewCell",
                for: indexPath) as? MasterCardDescriptionTableViewCell
                cell?.descriptionLabel.text = vm.masterViewModel.description
                
                return cell ?? UITableViewCell()
            case 1:
                return  tableView.dequeueReusableCell(withIdentifier: "MasterCardContactsTableViewCell",
                for: indexPath)
            case 2:
                let cell =   tableView.dequeueReusableCell(withIdentifier: "MasterCardWorkingHoursTableViewCell",
                for: indexPath) as? MasterCardWorkingHoursTableViewCell
                cell?.workingHoursLabel.text = vm.masterViewModel.workHours != nil ?
                    ("Сегодня:\n" +
                        Utilities.convertDateToTime(date: vm.masterViewModel.workHours!.everyday!.from) +
                    " - " +
                        Utilities.convertDateToTime(date: vm.masterViewModel.workHours!.everyday!.to)) :
                    "Нет данных"
                return cell ?? UITableViewCell()
            case 3:
                return  tableView.dequeueReusableCell(withIdentifier: "MasterCardPriceListTableViewCell",
                for: indexPath)
            default:
                return UITableViewCell()
            }
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "MasterCardReviewTableViewCell",
                                          for: indexPath) as! MasterCardReviewTableViewCell
            cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.systemBackground : UIColor.systemGroupedBackground
            print("Index path " + String(indexPath.item))
            cell.cellVM = vm.getReviewCellViewModel(at: indexPath.item)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousWorkTableViewCell",
            for: indexPath) as! PreviousWorkTableViewCell
            
            cell.cellVM = vm.worksViewModel.getCellViewModel(at: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (headSegmentedControl.selectedSegmentIndex==2) {
            vm.pressedWorkCell(at: indexPath)
            performSegue(withIdentifier: "showWorkInfo", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showWorkInfo":
            let vc = segue.destination as! WorkInfoTableViewController
            vc.itemID = vm.selectedWorkCell!.itemID!
            vc.workTitle = vm.selectedWorkCell!.title!
        default:
            let vc = segue.destination as! BookingViewController
            vc.uid = vm.masterViewModel.uid!
            vc.minimumDate = vm.masterViewModel.workHours!.everyday!.from
            vc.maximumDate = vm.masterViewModel.workHours!.everyday!.to
        }
    }

}
