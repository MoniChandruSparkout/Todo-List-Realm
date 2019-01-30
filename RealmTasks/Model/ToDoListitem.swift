//
//  ToDoListitem.swift
//  RealmTasks
//
//  Created by monichandru on 10/12/18.
//  Copyright © 2018 monichandru. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoListitem: Object{
    @objc dynamic var name = ""
    @objc dynamic var done = false
}
