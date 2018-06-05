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
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categoryArray = [Category]()
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        tableView.separatorStyle = .none
       
    }

    //MARK: TableView DataSource Methods
    
    //Determines number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return categoryArray.count
        return categories?.count ?? 1 //nil coalescing operator
    }
    
    //Allows cells to be formatted and dequeue for reuse
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6") 
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
    
   // MARK: Deletion
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    }
                    } catch {
                        print("Error deleting category, \(error)")
                    }
                }
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
            newCategory.color = UIColor.randomFlat.hexValue()
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
