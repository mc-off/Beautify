//
//  MapInfoWindow.swift
//  Beautify
//
//  Created by Артем Маков on 03.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

protocol MapMarkerDelegate: AnyObject {
    func didTapInfoButton(vm: MasterShortViewModel)
}

class MapInfoWindow: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var button: UIButton!
    
    
    var cellVM = MasterShortViewModel() {
        didSet {
            titleLabel.text = cellVM.name
            typeLabel.text = cellVM.type
        }
    }
    
    weak var delegate: MapMarkerDelegate?
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        print("Tapped in view")
        delegate?.didTapInfoButton(vm: cellVM)
    }
}
