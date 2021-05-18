//
//  IncomingBookingTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 17.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class IncomingBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var workingHours: UILabel!
    
    var cellVM = MasterShortViewModel() { didSet {
        titleLable.text = cellVM.name
        workingHours.text = cellVM.workHours != nil ? ("Открыто до " + Utilities.convertDateToTime(date: cellVM.workHours!.everyday!.to)) : "Нет данных"
    }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
