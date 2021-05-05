//
//  Item.swift
//  Beautify
//
//  Created by Артем Маков on 03.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class Item: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBAction func buttonTapped(_ sender: Any) {
        print("Tapped in view")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
