//
//  Master.swift
//  Beautify
//
//  Created by Артем Маков on 13.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

struct Master {
    var id: String?
    var coordinate: Coordinate?
    var description: String?
    var name: String?
    var address: String?
    var priceTier: Int?
    var profileImage: String?
    var type: String?
    var workHours: WorkHoursWeekly?
    var reviews: [String]?
    var grade: Double?
    var gradeAmount: Int?
    var contacts: [Contact]?
}

struct Coordinate {
    var longitude: Double
    var latitude: Double
}

struct WorkHoursWeekly {
    var everyday: WorkHours?
}

struct WorkHours {
    var from: Date
    var to: Date
}

struct Contact {
    var value: String?
    var type: ContactType?
}

enum ContactType: String {
    case phone
    case instagram
    case vk
    case site
}
