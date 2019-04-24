//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Durham on 4/22/19.
//  Copyright © 2019 Brian Durham. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // Get the app delegate's coredata context object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Delete code for later reference
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) // Flash background color on select then go back to standard bg
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Once user clicks 'Add Item' actions
            let newItem = Item(context: self.context)
            newItem.title = textField.text
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
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
    
    //MARK: - Model Manipulation Methods
    func saveItems(){
        do{
            try context.save()
        }
        catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - ToDoListViewController Extension
extension TodoListViewController: UISearchBarDelegate{
    
    //MARK: - Search Functionality
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request  : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Query filter
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Set the sort
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            // Make search bar no longer active
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
