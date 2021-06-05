//
//  MapInfoWindow.swift
//  Beautify
//
//  Created by Артем Маков on 03.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Cosmos

protocol MapMarkerDelegate: AnyObject {
    func didTapInfoButton(vm: MasterShortViewModel)
}

class MapInfoWindow: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var priceSegment: CosmosView!
    
    
    var cellVM = MasterShortViewModel() {
        didSet {
            titleLabel.text = cellVM.name
            typeLabel.text = cellVM.type
            stars.rating = cellVM.grade ?? 0
            stars.text = "(\(cellVM.gradeAmount ?? 0))"
            priceSegment.rating = Double(cellVM.priceTier ?? -1) + 1
        }
    }
    
    weak var delegate: MapMarkerDelegate?
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        print("Tapped in view")
        delegate?.didTapInfoButton(vm: cellVM)
    }
}
