//
//  ViewController.swift
//  RealmTasks
//
//  Created by monichandru on 10/12/18.
//  Copyright © 2018 monichandru. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {

    var realm: Realm!
    
    var toDoList: Results<ToDoListitem>{
        get{
            return realm.objects(ToDoListitem.self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        realm = try! Realm()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImage(named: "Blurred Background HD Mobile Wallpaper15.png")
        let imageview = UIImageView(image: backgroundImage)
        imageview.alpha = 0.3
        self.tableView.backgroundView = imageview
        
    }
    
    //Mark add DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = toDoList[indexPath.row]
        cell.textLabel!.text = item.name
        cell.backgroundColor = .clear
        
        //Ternary operator..........basically an if else statement on the line
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    //Mark - Add Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = toDoList[indexPath.row]
        try! self.realm.write ({
            item.done = !item.done
        })
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let item = toDoList[indexPath.row]
            
            try! self.realm.write ({
                self.realm.delete(item)
            })
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "New toDO", message: "What do you want to do?", preferredStyle: .alert)
        alertVC.addTextField { (UITextField) in
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        alertVC.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "add", style: .default) { (UIAlertAction) -> Void in
            
            let todoItemTextFeild = (alertVC.textFields?.first)! as UITextField
            
            let newToDoListItem = ToDoListitem()
            newToDoListItem.name = todoItemTextFeild.text!
            newToDoListItem.done = false
            
            try! self.realm.write ({
                self.realm.add(newToDoListItem)
                
                self.tableView.insertRows(at: [IndexPath.init(row: self.toDoList.count-1, section: 0)], with: .automatic)
            })
            }
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
            
    }

}

