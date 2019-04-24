//
//  Item.swift
//  Todoey
//
//  Created by Brian Durham on 4/24/19.
//  Copyright © 2019 Brian Durham. All rights reserved.
//

import Foundation

class Item{
    var title : String = ""
    var checked : Bool = false
    
    init(title: String, checked: Bool) {
        title = title
        checked = checked
    }
}
