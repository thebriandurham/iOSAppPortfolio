//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Durham on 4/22/19.
//  Copyright © 2019 Brian Durham. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Add checkmark as an accessory
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // Flash background color on select then go back to standard bg
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Once user clicks 'Add Item' actions
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        
        // Add text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item."
            textField = alertTextField
            }
        
        // Add action to the alert and present it
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

