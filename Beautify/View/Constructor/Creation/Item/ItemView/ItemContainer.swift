//
//  Item.swift
//  Beautify
//
//  Created by Артем Маков on 03.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

protocol ItemTappedDelegate: AnyObject {
    func didTapItem(itemVM: ItemViewModel)
}

class ItemContainer: UIView {
    
    
    var isSelected = false
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    var darkBackgroundView:UIView?

    
    var cellVM = ItemViewModel() { didSet {
        backgroundView.layer.cornerRadius = 20
        let color = UIColor(hex: cellVM.color!.uppercased())
        backgroundView.backgroundColor = color
        itemImage.KFloadImage(url: cellVM.imageURL!)
        titleLabel.text = cellVM.name
        if (!color.isDarkColor) {
            titleLabel.textColor = UIColor.black
        }
    }
    }

    
    weak var delegate:ItemTappedDelegate?
    
    override func draw(_ rect: CGRect) {
    
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.addGestureRecognizer(gesture)
    }
    
    

    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        delegate?.didTapItem(itemVM: cellVM)
        isSelected = !isSelected
        
        if(isSelected) {
            addOverlay()
        } else {
            dropOverlay()
        }
        
    }
    
    func addOverlay(color: UIColor = .black,alpha : CGFloat = 0.3) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.tag = 100
        overlay.layer.cornerRadius = 20
        overlay.backgroundColor = color
        overlay.alpha = alpha
        self.addSubview(overlay)
    }
    
    func dropOverlay() {
        print("Start remove sibview")
            if let viewWithTag = self.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }else{
                print("No!")
            }
    }

}
