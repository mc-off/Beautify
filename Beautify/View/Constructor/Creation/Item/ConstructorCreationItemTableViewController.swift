//
//  ConstructorCreationItemTableViewController.swift
//  Beautify
//
//  Created by Артем Маков on 10.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class ConstructorCreationItemTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal) // 22x22 1x, 44x44 2x, 66x66 3x
        button.setTitle("Form", for: .normal)
        button.sizeToFit()
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        let nextBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [nextBtn]
    }
    
    @objc func buttonAction(sender: Any) {
        performSegue(withIdentifier: "toForm", sender: self)
    }
    
}
