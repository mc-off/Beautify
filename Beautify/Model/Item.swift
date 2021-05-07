//
//  Item.swift
//  Beautify
//
//  Created by Артем Маков on 06.05.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

struct Item {
    var id: String?
    var color: String?
    var imageURL: String?
    var name: String?
    var type: ItemType?
}

enum ItemType: String {
    case glossy
    case matt
}
