//
//  FinalItemTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 07.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class FinalItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    var cellVM = ItemViewModel() { didSet {
        itemImage.KFloadImage(url: cellVM.imageURL!)
        itemTitleLabel.text = cellVM.name
        let color = UIColor(hex: cellVM.color!.uppercased())
        self.backgroundColor = color
        if (!color.isDarkColor) {
            itemTitleLabel.textColor = UIColor.black
        }
    }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        super.layer.cornerRadius = 20
        // Initialization code
    }
    
}
