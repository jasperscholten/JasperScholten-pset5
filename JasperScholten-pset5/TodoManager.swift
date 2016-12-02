//
//  TodoManager.swift
//  JasperScholten-pset5
//
//  Created by Jasper Scholten on 29-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import Foundation

class TodoManager {
    
    static let sharedInstance = TodoManager()
    
    private let db = DatabaseHelper()
    
    private init() {
        
        if db == nil {
            print("Error")
        }
        
        print("Initialized")
    
    }
    
    func count(list: String, tableName: String) -> Int {
        
        var count: Int = 0
        
        do {
            count = try db!.countRows(list: list, tableName: tableName)
        } catch {
            print(error)
        }
        
        return(count)
    }
    
    // Perhaps get list in as string and then convert it to list number?
    func write(title: String, list: String, tableName: String) {
        do {
            try db!.add(title: title, list: list, tableName: tableName)
        } catch {
            print(error)
        }
    }
    
    // not useful to put countRows here(?)
    // filter eerst op lijstnaam en populate dan pas.
    func read(index: Int, list: String, tableName: String) -> (String?, Bool) {
        
        var title: String? = ""
        var completed: Bool = false
        
        do {
            title = try db!.populate(index: index, list: list, tableName: tableName)
            completed = try db!.populateCompleted(index: index, list: list, tableName: "todo")
        } catch {
            print(error)
        }
        
        return(title, completed)
    }
    
    func delete(index: Int, tableName: String) {
        do {
            if tableName == "todo" {
                try db!.deleteTitle(index: index)
            } else {
                try db!.deleteList(index: index)
            }
        } catch {
            print(error)
        }
    }
    
    func selectListname(index: Int) -> String? {
        
        var listname: String? = ""
        
        do {
            listname = try db!.selectListname(index: index)
        } catch {
            print(error)
        }
        
        return(listname)
        
    }
    
    func completedSwitch(index: Int, list: String) {
        do {
            try db!.completedSwitch(index: index, list: list)
            print("index \(index), list \(list)")
        } catch {
            print(error)
        }
    }
    
}
