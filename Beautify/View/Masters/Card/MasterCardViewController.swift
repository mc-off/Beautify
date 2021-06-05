//
//  MasterCardViewController.swift
//  Beautify
//
//  Created by Артем Маков on 11.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Cosmos
import ASHorizontalScrollView

class MasterCardViewController: UIViewController, ContactTappedDelegate {
    
    func didTapItem(contact: Contact) {
        switch contact.type! {
        case .phone :
            if let url = URL(string: "telprompt://\(contact.value!)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        case ContactType.instagram :
            Utilities.openAction(username: contact.value!, appBaseURL: "instagram://user?username=", webBaseURL: "https://instagram.com/")
        case ContactType.vk :
            Utilities.openAction(username: contact.value!, appBaseURL: "vk://vk.com/", webBaseURL: "https://vk.com/")
        default:
            Utilities.openAction(username: contact.value!, appBaseURL: "", webBaseURL: "")
        }
    }

    
    public var masterTitle: String?
    public var masterType: String?
    public var uid : String?
    public var priceSegmentValue: Int?
    public var grade: Double?
    public var gradeAmount: Int?

    let kCellHeight = 46
    
    var horizontalScrollView: ASHorizontalScrollView?


    @IBOutlet weak var headTitleLabel: UILabel!
    @IBOutlet weak var headTypeLabel: UILabel!
    @IBOutlet weak var headSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var priceSegment: CosmosView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let vm = MasterCardViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headTitleLabel.text = masterTitle
        headTypeLabel.text = masterType
        priceSegment.rating = Double(priceSegmentValue ?? 0) + 1
        
        if let grade = grade {
            stars.rating = grade
            stars.text = "(\(gradeAmount ?? 0))"
        } else {
            stars.rating = 0
            stars.text = "(0)"
        }
    

        
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
                return "Обзор"
            case 1:
                return "Контакты"
            case 2:
                return "График работы"
            case 3:
                return "Прайс лист"
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCardContactsTableViewCell")
                
                horizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: Int(tableView.frame.size.width), height: kCellHeight))
                
                    
                horizontalScrollView!.defaultMarginSettings = MarginSettings(leftMargin: 16, miniMarginBetweenItems: 16, miniAppearWidthOfLastItem: 16)

                horizontalScrollView!.uniformItemSize = CGSize(width: kCellHeight, height: kCellHeight)
                   
                horizontalScrollView!.setItemsMarginOnce()
                
                if (!(vm.masterViewModel.contacts?.isEmpty ?? true)) {
                    for contact in vm.masterViewModel.contacts! {
                        let item = Bundle.main.loadNibNamed("ContactView", owner: self, options: nil)![0] as? ContactItemView
                        item?.contact = contact
                        item?.delegate = self

                        horizontalScrollView!.addItem(item!)
                    }
                }
                
                cell?.contentView.addSubview(horizontalScrollView!)
                horizontalScrollView!.translatesAutoresizingMaskIntoConstraints = false
                cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
                cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 7))
                cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 7))
                cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(60)))
                cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
                
                return cell!
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
