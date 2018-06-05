//
//  Item.swift
//  Todoey
//
//  Created by David Henshaw on 6/5/18.
//  Copyright © 2018 David Henshaw. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //name of obj, not class name
}