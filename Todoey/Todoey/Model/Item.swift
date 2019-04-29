//
//  Item.swift
//  Todoey
//
//  Created by Brian Durham on 4/29/19.
//  Copyright © 2019 Brian Durham. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
