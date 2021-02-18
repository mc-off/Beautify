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
            
        
    }
    
    private func initVM() {
        vm.loadInfoClosure = { [weak self] in
            guard let self = self else { return }
            
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
