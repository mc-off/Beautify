//
//  ActivityIndicator.swift
//  Beautify
//
//  Created by Артем Маков on 14.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit


struct ActivityIndicator {
    
    private static let activityIndicator = UIActivityIndicatorView()
    
    public static func initActivityIndecator(view: UIView) {
        activityIndicator.color = UIColor(named: "ActivityIndecatorColor")
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    public static func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    public static func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
}
