//
//  ContactItemView.swift
//  Beautify
//
//  Created by Артем Маков on 06.06.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

protocol ContactTappedDelegate: AnyObject {
    func didTapItem(contact: Contact)
}

class ContactItemView: UIView {

    @IBOutlet var iconView: UIImageView!
    @IBOutlet var backgroundView: UIView!
    
    var contact = Contact() { didSet {
        switch contact.type! {
        case .phone:
            iconView.image = UIImage(systemName: "phone.fill")
        case .site:
            iconView.image = UIImage(systemName: "network")
        case .instagram:
            iconView.image = UIImage(named: "instagram")
        case .vk:
            iconView.image = UIImage(named: "vk")
        default:
            iconView.isHidden = true
        }
    }
    }
    
    weak var delegate:ContactTappedDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    
    override func draw(_ rect: CGRect) {
        backgroundView.layer.cornerRadius = 6
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.addGestureRecognizer(gesture)
    }

    @objc func checkAction(sender : UITapGestureRecognizer) {
        delegate?.didTapItem(contact: contact)
        
    }
}
