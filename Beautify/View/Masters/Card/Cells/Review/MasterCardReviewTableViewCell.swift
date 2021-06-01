//
//  MasterCardReviewTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 11.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Cosmos

class MasterCardReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    
    
    var cellVM = ReviewViewModel() { didSet
        {
            topImage.KFloadImage(url: cellVM.topImageURL!)
            usernameLabel.text = cellVM.username
        statusLabel.text = cellVM.status
        ratingView.rating = Double(cellVM.grade!)
            descriptionLabel.text = cellVM.description
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
