//
//  Alert.swift
//  Beautify
//
//  Created by Артем Маков on 14.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

struct Alert {
    
    static func showAlert(at viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "ToolActive")

        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}
