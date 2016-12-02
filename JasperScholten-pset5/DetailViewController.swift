//
//  DetailViewController.swift
//  JasperScholten-pset5
//
//  Created by Jasper Scholten on 28-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
    }
    
    func reloadTableData(_ notification: Notification) {
        todoTableView.reloadData()
    }

    
    
    // MARK: insert object
    
    func insertNewObject(_ sender: Any) {
        
        // Check if a list has been selected.
        if(self.detailItem != nil) {
            // http://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
            let alert = UIAlertController(title: "Add a new todo item", message: "Enter what you want to do", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "todo item"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                
                TodoManager.sharedInstance.write(title: (textField?.text!)!, list: self.detailItem!, tableName: "todo")
                self.todoTableView.reloadData()
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Select a list", message: "Or create a new list.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func setSwitch(_ sender: Any) {
        
        // Method to retrieve the indexpath of the cell that the user clicks on. http://stackoverflow.com/questions/39603922/getting-row-of-uitableview-cell-on-button-press-swift-3
        let switchPos = (sender as AnyObject).convert(CGPoint.zero, to: todoTableView)
        let indexPath = todoTableView.indexPathForRow(at: switchPos)
            
        TodoManager.sharedInstance.completedSwitch(index: (indexPath?.row)!, list: self.detailItem!)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Use to choose which list will show.
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            print(detail)
        }
    }
    
    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if(self.detailItem != nil) {
            rows = TodoManager.sharedInstance.count(list: self.detailItem!, tableName: "todo")
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! todoTableViewCell
        
        cell.todoItem.text = TodoManager.sharedInstance.read(index: indexPath.row, list: self.detailItem!, tableName: "todo").0
        let completedState = TodoManager.sharedInstance.read(index: indexPath.row, list: self.detailItem!, tableName: "todo").1
        
        cell.todoSwitch.setOn(completedState, animated: true)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoManager.sharedInstance.delete(index: indexPath.row, tableName: "todo")
            todoTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

