//
//  FinalInformationTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 07.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class FinalInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.addPrefix(labelText: "Название")
        // Initialization code
    }
    
}
