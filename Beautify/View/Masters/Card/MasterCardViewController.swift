//
//  MasterCardViewController.swift
//  Beautify
//
//  Created by Артем Маков on 11.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class MasterCardViewController: UIViewController {

    @IBOutlet weak var headTitleLabel: UILabel!
    @IBOutlet weak var headTypeLabel: UILabel!
    @IBOutlet weak var headSegmentedControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headSegmentedControl.superview?.clipsToBounds = true
        
        tableView.contentInsetAdjustmentBehavior = .automatic

        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: CGFloat.leastNormalMagnitude)))

        
        tableView.register(UINib(nibName: "MasterCardDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardDescriptionTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardWorkingHoursTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardWorkingHoursTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardContactsTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardPriceListTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardPriceListTableViewCell")
        
        tableView.register(UINib(nibName: "MasterCardReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterCardReviewTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func headSegmentedControlValueChanged(_ sender: Any) {
        tableView.reloadData()
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
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch headSegmentedControl.selectedSegmentIndex {
        case 0:
            switch indexPath.section {
            case 0:
                return  tableView.dequeueReusableCell(withIdentifier: "MasterCardDescriptionTableViewCell",
                for: indexPath)
            case 1:
                return  tableView.dequeueReusableCell(withIdentifier: "MasterCardContactsTableViewCell",
                for: indexPath)
            case 2:
                return  tableView.dequeueReusableCell(withIdentifier: "MasterCardWorkingHoursTableViewCell",
                for: indexPath)
            case 3:
                return  tableView.dequeueReusableCell(withIdentifier: "MasterCardPriceListTableViewCell",
                for: indexPath)
            default:
                return UITableViewCell()
            }
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "MasterCardReviewTableViewCell",
                                          for: indexPath)
            cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.systemBackground : UIColor.systemGroupedBackground
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let headerView = view as? UITableViewHeaderFooterView else { return }
//        headerView.tintColor = .clear //use any color you want here .red, .black etc
//    }
    

}
