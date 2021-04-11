//
//  ConstructorCreationFormTableViewController.swift
//  Beautify
//
//  Created by Артем Маков on 11.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class ConstructorCreationFormTableViewController: UITableViewController {
    //formSelection

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ConstructorCreationFormTableViewCell", bundle: nil), forCellReuseIdentifier: "ConstructorCreationFormTableViewCell")
        
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
        performSegue(withIdentifier: "toFinal", sender: self)
    }

}

extension ConstructorCreationFormTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
         return 216 // custom height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConstructorCreationFormTableViewCell", for: indexPath) as! ConstructorCreationFormTableViewCell

        cell.formLabel.text = Utilities.randomString(of: 8)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFinish", sender: self)
    }
}
