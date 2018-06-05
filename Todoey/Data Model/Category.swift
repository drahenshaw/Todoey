//
//  Category.swift
//  Todoey
//
//  Created by David Henshaw on 6/5/18.
//  Copyright © 2018 David Henshaw. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() //empty array of item objects
    
}
