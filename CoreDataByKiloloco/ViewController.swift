//
//  ViewController.swift
//  CoreDataByKiloloco
//
//  Created by Sukumar Anup Sukumaran on 03/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchRequest()
    }
    
    func fetchRequest() {
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        // or -> let fetchRequest = Person.fetchRequest()
        do {
           let people =  try  PersistenceService.context.fetch(fetchRequest)
            self.people = people
            self.tableView.reloadData()
            
        } catch let error {
            print("Error = \(error.localizedDescription)")
        }
       
        
    }

    
    @IBAction func onePlusTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Age"
            textfield.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "Post", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let age = alert.textFields!.last!.text!
            
            
            
            let person = Person(context: PersistenceService.context)
            person.name = name
            person.age = Int16(age)!
            PersistenceService.saveContext()
            self.people.append(person)
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

extension ViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = String(people[indexPath.row].age)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete{
            
            let person = people[indexPath.row]
            PersistenceService.context.delete(person)
            PersistenceService.saveContext()
            
            do{
                
                people = try PersistenceService.context.fetch(Person.fetchRequest())
                
            }catch let error {
                print("Error = \(error.localizedDescription)")
            }
            
            
        }
        self.tableView.reloadData()
    }
    
}

