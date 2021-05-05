//
//  ConstructorCreationItemTableViewController.swift
//  Beautify
//
//  Created by Артем Маков on 10.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import ASHorizontalScrollView

class ConstructorCreationItemTableViewController: UITableViewController {

    let kCellHeight = 280
    
    let vm = WorksViewModel()

    
    
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

extension ConstructorCreationItemTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let indentifier = "CellPortrait"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: indentifier)
            cell?.selectionStyle = .none
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: Int(tableView.frame.size.width), height: kCellHeight))
            
                //instead of using frame to determine margin, using number of items per screen to calculate margin maybe eaiser than setting mini margin for multiple screen size
                horizontalScrollView.arrangeType = .byNumber
                
                horizontalScrollView.marginSettings_375 = MarginSettings(leftMargin: 16, numberOfItemsPerScreen: 1.75)
                horizontalScrollView.marginSettings_320 = MarginSettings(leftMargin: 16, numberOfItemsPerScreen: 1.5)
                //for all the other screen sizes which are not set here, margin would be calculated by frame instead
                
                horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 16, numberOfItemsPerScreen: 1.8)
                
                horizontalScrollView.uniformItemSize = CGSize(width: 186, height: 280)
                //this must be called after changing any size or margin property of this class to get acurrate margin
                horizontalScrollView.setItemsMarginOnce()
            switch indexPath.section {
            case 0:
                for _ in 1...20{
                    
                    let item = Bundle.main.loadNibNamed("ItemView", owner: self, options: nil)![0] as? Item
                    
                    item?.backgroundView.layer.cornerRadius = 20
                    
                    horizontalScrollView.addItem(item!)
                }
                
            default:
                for _ in 1...20{
                    
                    let item = Bundle.main.loadNibNamed("ItemView", owner: self, options: nil)![0] as? Item
                    
                    item?.backgroundView.backgroundColor = UIColor.blue
                    item?.backgroundView.layer.cornerRadius = 20
                    
                    horizontalScrollView.addItem(item!)
                }
            }
                
            cell?.contentView.addSubview(horizontalScrollView)
            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(kCellHeight)))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
        }
        else if let horizontalScrollView = cell?.contentView.subviews.first(where: { (view) -> Bool in
            return view is ASHorizontalScrollView
        }) as? ASHorizontalScrollView {
            horizontalScrollView.refreshSubView() //refresh view incase orientation changes
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(kCellHeight)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let itemTitle = Bundle.main.loadNibNamed("ItemSectionTitleView", owner: self, options: nil)![0] as? ItemSectionTitle
        switch section {
        case 0:
            itemTitle?.titleLabel.text = "Глянцеый лак"
        default:
            itemTitle?.titleLabel.text = "Матовый лак"
        }
        return itemTitle
    }
    
    
}
