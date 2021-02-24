//
//  HomeViewController.swift
//  Beautify
//
//  Created by Артем Маков on 08.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    let vm = HomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initVM()
        tableView.reloadData()
    }
    
    
    
    
    
    
    // MARK:- Init view and view model
    
    private func initView() {
        profileImage.layer.cornerRadius = 50
                
        tabBarController?.tabBar.clipsToBounds = true
    }
    
     private func initVM() {
         vm.loadInfoClosure = { [weak self] in
             guard let self = self else { return }
             guard let first = self.vm.user.first else { return }
             guard let last = self.vm.user.last else { return }
             self.titleLabel.text = first + " " + last
             if let image = self.vm.user.image {
                 self.profileImage.image = image
             } else {
                 guard let url = self.vm.user.imageURL else { return }
                 self.profileImage.load(url: url)
             }
         }
         vm.loadInfo()
     }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure to sign out?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Sign Out", style: .destructive, handler: { [weak self](_) in
            guard let self = self else { return }
            FBAuthentication.shared.signOutUser { (isSuccess, error) in
                if error != nil {
                    Alert.showAlert(at: self, title: "Sign Out Validation", message: error!)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: Identifiers.login)
                    loginVC.modalTransitionStyle = .crossDissolve
                    self.present(loginVC, animated: true)
                }
            }
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }


   
}

// MARK:- TableView datasource and delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return HeaderView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "draft"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 180
        case 1:
            return 30
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        if row == 0 && section == 0 {
            cell.textLabel?.text = "Edite Profile"
        } else if row == 1 && section == 0 {
            cell.textLabel?.text = "Change Password"
        } else if row == 0 && section == 1 {
            cell.textLabel?.text = "Privacy Policy"
        } else if row == 1 && section == 1 {
            cell.textLabel?.text = "Terms of Service"
        } else if row == 0 && section == 2 {
            cell.textLabel?.text = "Sign Out"
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.3032806202, blue: 0.02296007777, alpha: 1)
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            let alert = UIAlertController(title: "Are you sure to sign out?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(.init(title: "Sign Out", style: .destructive, handler: { [weak self](_) in
                guard let self = self else { return }
                FBAuthentication.shared.signOutUser { (isSuccess, error) in
                    if error != nil {
                        Alert.showAlert(at: self, title: "Sign Out Validation", message: error!)
                    } else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                        loginVC.modalTransitionStyle = .crossDissolve
                        self.present(loginVC, animated: true)
                    }
                }
            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        } else if indexPath.section == 0 && indexPath.row == 1 {
            performSegue(withIdentifier: "changePassword", sender: self)
        } else if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "editeProfile", sender: self)
        } else if indexPath.section == 1 {
            Alert.showAlert(at: self, title: "We will add it soon, Stay tune", message: "")
        }
    }
    
}

