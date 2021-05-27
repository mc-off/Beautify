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
    
    var cellVM = WorkViewModel() { didSet {
        workImage.KFloadImage(url: cellVM.photoURL ?? "https://www.pngitem.com/pimgs/m/143-1432762_nails-png-transparent-png.png")
        itemLabel.text = cellVM.title
    }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        workImage.contentMode = .scaleAspectFit
        workImage.layer.cornerRadius = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
