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
    
    static func convertDateToCalendar(date:Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.YYYY"
        
        return String(df.string(from: date))
    }
    
    static func convertDateToFullCalendar(date:Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.YYYY HH:mm"
        
        return String(df.string(from: date))
    }
    
    static func dayDifference(date:Date) -> String
    {
        let calendar = Calendar.current
        if calendar.isDateInYesterday(date) { return "Вчера" }
        else if calendar.isDateInToday(date) { return "Сегодня" }
        else if calendar.isDateInTomorrow(date) { return "Завтра" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            switch (day) {
            case _ where day < -5:
                return convertDateToCalendar(date: date)
            case -4 ... -2:
                return "\(day) дня назад"
            case 2...4:
                return "Через \(day) дня"
            default:
                return "Через \(day) дней"
            }
        }
    }
}
