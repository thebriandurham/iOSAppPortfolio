//
//  Category.swift
//  Todoey
//
//  Created by Brian Durham on 4/29/19.
//  Copyright © 2019 Brian Durham. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
