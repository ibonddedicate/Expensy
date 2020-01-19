//
//  ViewController.swift
//  Expensy
//
//  Created by Surote Gaide on 12/1/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, AddingDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var currencyPicked = " ฿"
    var expenseArray = [Item]()
    var editStatus = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
    super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.shadowImage = UIImage()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    func addingData(data: Item) {
        expenseArray.append(data)
        saveItems()
        tableView.reloadData()
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        editStatus = !tableView.isEditing
        tableView.setEditing(editStatus, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddScreen"{
            let vc : AddingController = segue.destination as! AddingController
            vc.delegate = self
        }
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving Context \(error)")
        }
    }
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            expenseArray = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print ("Error feting request \(error)")
        }
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        cell.textLabel?.text = expenseArray[indexPath.row].expenseTitle
        cell.detailTextLabel?.text = String(expenseArray[indexPath.row].cash) + currencyPicked
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(expenseArray[indexPath.row])
            expenseArray.remove(at: indexPath.row)
            saveItems()
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
