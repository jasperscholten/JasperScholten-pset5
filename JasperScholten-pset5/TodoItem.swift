//
//  TodoItem.swift
//  JasperScholten-pset5
//
//  Created by Jasper Scholten on 29-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import Foundation
import SQLite

class TodoItem {
 
    // store attributes of item here
    let id = Expression<Int64>("id")
    let list = Expression<String?>("list")
    let title = Expression<String?>("title")
    let completed = Expression<Bool>("completed")
    
}
