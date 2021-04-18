//
//  Utilities.swift
//  Beautify
//
//  Created by Артем Маков on 09.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Foundation

class Utilities {
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
    }
    
    static func isPasswordValid(_ password:String) -> Bool {
        
        
        
    let passwordTest = NSPredicate(format: "SELF MATCHES %@ ", "^[a-zA-Z0-9]{6,}$")
        //                                       "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isTextFieldEmpty(_ textField:UITextField) -> Bool {
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    static func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    static func convertDateToTime(date:Date) -> String {
        let calendar = Calendar.current
        let df = DateFormatter()
        df.dateFormat = "mm"
        
        return String(calendar.component(.hour, from: date)) +
            ":" +
            df.string(from: date)
    }
}
