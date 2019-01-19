//
//  ToDoListTableViewController.swift
//  ToDoApp
//
//  Created by 掛川優希 on 1/16/19.
//  Copyright © 2019 Yuki Kakegawa. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var listItems : Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        if let item = listItems?[indexPath.row]{
            cell.textLabel?.text = item.subName
            
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = listItems?[indexPath.row]{
            do {
                try realm.write {
                item.done = !item.done
                }}catch{
                    print("Error!...\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            //Happinning nothing
            print("Adding Canceled...")
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.subName = textField.text!
                        currentCategory.items.append(newItem)
                    }}catch{
                        print("Error!..\(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create New Item"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
//    func save(item: Item){
//        do {
//            try realm.write {
//                realm.add(item)
//            }}catch{
//                print("Error...\(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func loadItems(){
        listItems = selectedCategory?.items.sorted(byKeyPath: "subName", ascending: true)
        tableView.reloadData()
    }
    
    
   
}
