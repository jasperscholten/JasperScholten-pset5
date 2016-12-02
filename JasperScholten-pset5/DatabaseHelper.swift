//
//  DatabaseHelper.swift
//  JasperScholten-pset5
//
//  Created by Jasper Scholten on 29-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    private let todo = Table("todo")
    private let lists = Table("lists")
    
    private let todoItem = TodoItem()
    private let todoList = TodoList()
    
    private var db: Connection?
    
    // MARK: - Setup
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
            
        } catch {
            throw error
        }
    }
    
    private func createTable() throws {
        do {
            try db!.run(todo.create(ifNotExists: true) {
                t in
                
                t.column(todoItem.id, primaryKey: .autoincrement)
                t.column(todoItem.list)
                t.column(todoItem.title)
                t.column(todoItem.completed)
            })
            try db!.run(lists.create(ifNotExists: true) {
                t in
                
                t.column(todoList.id, primaryKey: .autoincrement)
                t.column(todoList.list, unique: true)
            })
        } catch {
            throw error
        }
    }
    
    // MARK: - Populate tables
    
    func countRows(list: String, tableName: String) throws -> Int {
        do {
            if tableName == "todo" {
                let selection = todo.filter(todoItem.list == list)
                return try db!.scalar(selection.count)
            } else {
                return try db!.scalar(lists.count)
            }
        } catch {
            throw error
        }
    }
    
    func populate(index: Int, list: String, tableName: String) throws -> String? {
        
        var result: String?
        var count = 0
        
        do {
            if tableName == "todo" {
                let selection = todo.filter(todoItem.list == list)
                for row in try db!.prepare(selection) {
                    if count == index {
                        result = "\(row[todoItem.title]!)"
                    }
                    count += 1
                }
            } else {
                for row in try db!.prepare(lists) {
                    if count == index {
                        result = "\(row[todoList.list]!)"
                    }
                    count += 1
                }
            }
        } catch {
            throw error
        }

        return result
    }
    
    func populatecompleted(index: Int, tableName: String) throws -> Bool {
        
        var result = false
        var count = 0
        
        do {
            for list in try db!.prepare(todo) {
                if count == index {
                    result = list[todoItem.completed]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        return(result)
    }
    
    // MARK: - Modifying tables
    
    func add(title: String, list: String, tableName: String) throws {
        
        var rowID: Int64 = 0
        
        do {
            if tableName == "todo" {
                rowID = try db!.run(todo.insert(todoItem.title <- title, todoItem.list <- list, todoItem.completed <- false))
            } else {
                rowID = try db!.run(lists.insert(todoList.list <- list))
            }
        } catch {
            print(error)
        }
        
        print(rowID)
        
    }
    
    func completedSwitch(index: Int) throws {
        
        var rowID: Int64
        var rowcompleted: Bool
        rowID = 0
        rowcompleted = false
        var count = 0
        
        do {
            for row in try db!.prepare(todo.select(todoItem.id, todoItem.completed)) {
                if count == index {
                    rowID = row[todoItem.id]
                    rowcompleted = row[todoItem.completed]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let rowState = todo.filter(todoItem.id == rowID)
        
        if(rowcompleted == false) {
            do {
                let number = try db!.run(rowState.update(todoItem.completed <- true))
                print("\(number) rows completed")
            } catch {
                print(error)
            }
        } else {
            do {
                let number = try db!.run(rowState.update(todoItem.completed <- false))
                print("\(number) rows completed")
            } catch {
                print(error)
            }
        }
    }
    
    
    func deleteTitle(index: Int) throws {
        
        var rowID: Int64
        rowID = 0
        var count = 0
        
        do {
            for row in try db!.prepare(todo) {
                if count == index {
                    rowID = row[todoItem.id]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let title = todo.filter(todoItem.id == rowID)
        
        do {
            let number = try db!.run(title.delete())
            print("\(number) row deleted")
        } catch {
            print(error)
        }
    }
    
    func deleteList(index: Int) throws {
        var rowID: Int64 = 0
        var listname: String = ""
        var count = 0
        
        do {
            for row in try db!.prepare(lists) {
                if count == index {
                    rowID = row[todoList.id]
                    listname = row[todoList.list]!
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let list = lists.filter(todoList.id == rowID)
        let title = todo.filter(todoItem.list == listname)
        
        do {
            let number = try db!.run(list.delete())
            print("\(number) list row deleted")
        } catch {
            print(error)
        }
        
        do {
            let number = try db!.run(title.delete())
            print("\(number) todo row(s) deleted")
        } catch {
            print(error)
        }
        
    }
    
    func selectListname(index: Int) throws -> String? {
        var listname: String? = ""
        var count = 0
        
        do {
            for row in try db!.prepare(lists) {
                if count == index {
                    listname = row[todoList.list]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        return(listname)
    }
    
}
