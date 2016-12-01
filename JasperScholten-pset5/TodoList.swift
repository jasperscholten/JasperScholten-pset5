//
//  TodoList.swift
//  JasperScholten-pset5
//
//  Created by Jasper Scholten on 29-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import Foundation
import SQLite

class TodoList {
    
    // store attributes of list here
    let id = Expression<Int64>("id")
    let list = Expression<String?>("list")
    
}
