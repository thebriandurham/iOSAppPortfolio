//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Brian Durham on 4/24/19.
//  Copyright © 2019 Brian Durham. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // Once user clicks 'Add Item' actions
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
        }
        
        // Add text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category."
            textField = alertTextField
        }
        
        // Add action to the alert and present it
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories defined yet."
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}
