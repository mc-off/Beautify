//
//  HomeViewController.swift
//  Beautify
//
//  Created by Артем Маков on 08.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {
    
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
    }
    
    
    
    
    
    
    // MARK:- Init view and view model
    
    private func initView() {
        profileImage.layer.cornerRadius = 50
                
        tabBarController?.tabBar.clipsToBounds = true
        
        tableView.register(UINib(nibName: "IncomingBookingTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomingBookingTableViewCell")
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
         vm.reloadTableViewClosure = { [weak self] in
                guard let self = self else { return }
            if self.vm.bookedMaster.uid == nil {
                } else {
                    self.tableView.reloadData()
                }
            }
        
         vm.loadBookingInfo()
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

    @IBAction func editeButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "editeProfile", sender: self)
    }
    
   
}

// MARK:- TableView datasource and delegate

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch  vm.bookedMaster.uid==nil {
        case true:
            return 4
        default:
            return 6
        }
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0 {
                return HeaderView
            } else {
                return nil
            }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch  vm.bookedMaster.uid==nil {
        case true:
            switch section {
            case 1:
                return "Профиль"
            case 2:
                return "Информация"
            default:
                return nil
            }
        default:
            switch section {
            case 1:
                return "Предстоящая запись"
            case 2:
                return "Заказы"
            case 3:
                return "Профиль"
            case 4:
                return "Информация"
            default:
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if vm.bookedMaster.uid==nil {
                return 44
            } else {
                return 160
            }
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            switch  vm.user.id==nil {
            case true:
                return 40
            default:
                return 160
            }
        case 1:
            switch  vm.bookedMaster.uid==nil {
            case true:
                return 40
            default:
                return 0
            }
        case 5:
            return 0
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  vm.bookedMaster.uid==nil {
        case true:
            switch section {
            case 0:
                return 0
            case 2:
                return 2
            default:
                return 1
            }
        default:
            switch section {
            case 0:
                return 0
            case 4:
                return 2
            default:
                return 1
            }
        }
        
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var section = indexPath.section
        if (vm.bookedMaster.uid==nil ){
            section = section + 2
        }
        switch section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingBookingTableViewCell", for: indexPath) as? IncomingBookingTableViewCell
            cell?.cellVM = vm.bookedMaster
            cell?.cellBookingVM = vm.bookingViewModel
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Прошлые заказы"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Сменить пароль"
            return cell
        case 4:
            switch row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "Правила политики использования"
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "Условия обслуживания"
                return cell
            }
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Выход из аккаунта"
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.3032806202, blue: 0.02296007777, alpha: 1)
            cell.accessoryType = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var section = indexPath.section
        if (vm.bookedMaster.uid==nil ){
            section = section + 2
        }
        switch  section{
        case 1:
            performSegue(withIdentifier: "currentBooking", sender: self)
        case 2:
            performSegue(withIdentifier: "bookingHistory", sender: self)
        case 3:
            performSegue(withIdentifier: "changePassword", sender: self)
        case 4:
            Alert.showAlert(at: self, title: "КТТС", message: "")
        case 5:
            let alert = UIAlertController(title: "Вы действительно хотите выйти?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(.init(title: "Да", style: .destructive, handler: { [weak self](_) in
                guard let self = self else { return }
                FBAuthentication.shared.signOutUser { (isSuccess, error) in
                    if error != nil {
                        Alert.showAlert(at: self, title: "Вы успешно вышли из аккаунта", message: error!)
                    } else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                        loginVC.modalTransitionStyle = .crossDissolve
                        self.present(loginVC, animated: true)
                    }
                }
            }))
            alert.addAction(.init(title: "Отменить", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        default:
            print("tapped " + String(indexPath.section)+":"+String(indexPath.row))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currentBooking" {
            let vc = segue.destination as! BookingInfoViewController
            vc.masterID = vm.bookingViewModel.masterID!
            vc.bookingVM = vm.bookingViewModel
        }
    }
    
}

