//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Henshaw on 6/5/18.
//  Copyright © 2018 David Henshaw. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: TableView DataSource Methods
    
    //Determines number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return categoryArray.count
        return categories?.count ?? 1 //nil coalescing operator
    }
    
    //Allows cells to be formatted and dequeue for reuse
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //let category = categories[indexPath.row]
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        return cell
    }
    
    //MARK: Data Manipulation Methods
    
    //Save Categories to SQLite/Realm
    func saveCategories(category: Category) {
        do {
            //try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //Load Categories from SQLite, request default or manual
    func loadCategories() {
        categories = realm.objects(Category.self)
        
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context, \(error)")
//        }
        tableView.reloadData()
    }
    
    
    //MARK: Add New Categories

    //Creates new Category object, adds to array
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //let newCategory = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!
            //self.categoryArray.append(newCategory)
            self.saveCategories(category: newCategory)
        }
        
        //Creates new alert with required action to name the category
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: TableView Delegate Methods
    
    //User selects category - move to Item view controller?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //destinationVC.selectedCategory = categoryArray[indexPath.row]
            destinationVC.selectedCategory = categories?[indexPath.row] 
        }
    }
    
    
}
