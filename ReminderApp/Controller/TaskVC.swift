//
//  ViewController.swift
//  ReminderApp
//
//  Created by Ondřej Svojše on 20.11.17.
//  Copyright © 2017 Ondřej Svojše. All rights reserved.
//

import UIKit
import CoreData

// Makes appDelegate accesible from diffrent VCs
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class TaskVC: UIViewController {
    // Tasks array
    var tasks: [Task] = []

    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.reloadData()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.isHidden = false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDatas()
        myTableView.reloadData()
    }
    

    // Fetch datas function
    func fetchDatas() {
        self.fetch { (complete) in
            if complete {
                if tasks.count >= 1 {
                    myTableView.isHidden = false
                } else {
                    myTableView.isHidden = true
                }
            }
        }
    }
    
}

extension TaskVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Returns count of element in tasks[] array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    // Creating cell from configureCell method template
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell else { return UITableViewCell() }
        let task = tasks[indexPath.row]
        cell.configureCell(deadlineDate: task.deadlineDate!, note: task.note!)
        print(task)
        return cell
    }
    // Enabling editing of cells
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    // Delete Editing
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeTask(atIndexPath: indexPath)
            self.fetchDatas()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
    
    
}

extension TaskVC {
    
    // Accessing CoreData and removing record
    func removeTask(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(tasks[indexPath.row])
        
        do {
            //Removing object from DB
            try managedContext.save()
            print("Succcess")
        } catch {
            // In case of failure printing error
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    // Function to fetch datas from CoreData DB
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        // Trying to fetch datas
        do {
            tasks = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            // In case of failure printing error
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}

