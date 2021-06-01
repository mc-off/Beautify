//
//  BookingInfoTimeTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 27.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class BookingInfoTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    var cellVM = BookingObjectViewModel() { didSet {
            timeLabel.text = cellVM.bookDate != nil ? (Utilities.dayDifference(date: cellVM.bookDate!) + " в " + Utilities.convertDateToTime(date: cellVM.bookDate!)) : "Нет данных"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
