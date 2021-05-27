//
//  BookingInfoMasterTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 27.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class BookingInfoMasterTableViewCell: UITableViewCell {

    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var cellVM = MasterShortViewModel() { didSet {
        titileLabel.text = cellVM.name
        typeLabel.text = cellVM.type
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
