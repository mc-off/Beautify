//
//  ConstructorCreationFormTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 09.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class ConstructorCreationFormTableViewCell: UITableViewCell {

    @IBOutlet weak var formImage: UIImageView!
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
