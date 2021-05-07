//
//  ARTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 07.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class ARTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        button.imageView!.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}