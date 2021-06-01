//
//  MasterTableViewCell.swift
//  Beautify
//
//  Created by Артем Маков on 01.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos

class MasterTableViewCell: UITableViewCell {
    var geocoder = Geocoder(geocoder: GMSGeocoder())
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var iconsView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
   
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var priceRange: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10.0
        view.layer.masksToBounds = false
        
        profileImage.layer.cornerRadius = 21
    }
    
    var cellVM = MasterShortViewModel() { didSet {
        profileImage.KFloadImage(url: cellVM.profileImage!)
        nameLabel.text = cellVM.name
        typeLabel.text = cellVM.type
        stars.rating = cellVM.grade ?? 0
        priceRange.rating = Double(cellVM.priceTier!+1)
        geocoder.reverseGeocodeCoordinate(cellVM.coordinate!) { [weak self] success, address in
            guard
                success == true,
                let address = address
            else { return }
            
            self?.addressLabel.text = address
        }
        
        workingHoursLabel.text = cellVM.workHours != nil ? ("Открыто до " + Utilities.convertDateToTime(date: cellVM.workHours!.everyday!.to)) : "Нет данных"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
