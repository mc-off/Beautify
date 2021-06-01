//
//  BookingTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 27.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var cellVM = BookingObjectViewModel() { didSet {
            titleLabel.text = cellVM.masterName
            detailLabel.text = cellVM.bookDate != nil ? (Utilities.dayDifference(date: cellVM.bookDate!) + " в " + Utilities.convertDateToTime(date: cellVM.bookDate!)) : "Нет данных"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
