//
//  IncomingBookingTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 17.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import ASHorizontalScrollView

class IncomingBookingTableViewCell: UITableViewCell, ContactTappedDelegate {
    
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
    
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var workingHours: UILabel!
    
    let kCellHeight = 46
    
    var horizontalScrollView: ASHorizontalScrollView?
    
    var cellVM = MasterShortViewModel() { didSet {
        titleLable.text = cellVM.name
        
        horizontalScrollView!.removeAllItems()
        if (!(cellVM.contacts?.isEmpty ?? true)) {
            for contact in cellVM.contacts! {
                let item = Bundle.main.loadNibNamed("ContactView", owner: self, options: nil)![0] as? ContactItemView
                item?.contact = contact
                item?.delegate = self

                horizontalScrollView!.addItem(item!)
            }
        }
    }
    }
    
    var cellBookingVM = BookingObjectViewModel() {
        didSet {
            workingHours.text = cellVM.workHours != nil ? (Utilities.dayDifference(date: cellBookingVM.bookDate!) + " в " + Utilities.convertDateToTime(date: cellBookingVM.bookDate!)) : "Нет данных"
            
        }
    }
    
    override func awakeFromNib() {
        horizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: Int(self.frame.size.width), height: kCellHeight))
        
            
        horizontalScrollView!.defaultMarginSettings = MarginSettings(leftMargin: 16, miniMarginBetweenItems: 16, miniAppearWidthOfLastItem: 16)

        horizontalScrollView!.uniformItemSize = CGSize(width: kCellHeight, height: kCellHeight)
           
        horizontalScrollView!.setItemsMarginOnce()
        
        self.contentView.addSubview(horizontalScrollView!)
        horizontalScrollView!.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: workingHours, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 12))
        self.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 12))
        self.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(70)))
        self.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
