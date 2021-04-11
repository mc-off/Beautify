//
//  PreviousWorkTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 09.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class PreviousWorkTableViewCell: UITableViewCell {
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var formLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
