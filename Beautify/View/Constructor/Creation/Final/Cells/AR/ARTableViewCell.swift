//
//  ARTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 07.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

protocol ARButtonDelegate: AnyObject {
    func buttonTapped()
}

class ARTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        button.imageView!.contentMode = .scaleAspectFit
    }
    weak var delegate: ARButtonDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.buttonTapped()
    }
}
