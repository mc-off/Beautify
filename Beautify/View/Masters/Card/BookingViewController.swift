//
//  BookingViewController.swift
//  Beautify
//
//  Created by Артем Маков on 15.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var vm = BookingViewModel()
    var uid = String()
    var minimumDate = Date()
    var maximumDate = Date()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.minimumDate = minimumDate
        timePicker.maximumDate = maximumDate
        
        vm.showAlertClosure = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
            Alert.showAlert(at: self, title: "", message: self.vm.messageAlert!)
        }
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        vm.createPressed(masterID: uid, bookDate: timePicker.date)
    }
    

}
