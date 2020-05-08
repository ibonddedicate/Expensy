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
    @IBOutlet weak var totalNumber: UILabel!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    
    var expenseArray = [Item]()
    var editStatus = false
    let chooseInterval = [1:1,2:7,3:30,4:365]
    var choosenInterval = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var totalAmount:Double = 0
    let accentColor = UIColor(red: 132/255.0, green: 196/255.0, blue: 103/255.0, alpha: 1)
    
    override func viewDidLoad() {
    super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.shadowImage = UIImage()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        dailyButton.layer.cornerRadius = dailyButton.frame.size.height/2
        weeklyButton.layer.cornerRadius = weeklyButton.frame.size.height/2
        monthlyButton.layer.cornerRadius = monthlyButton.frame.size.height/2
        yearlyButton.layer.cornerRadius = yearlyButton.frame.size.height/2
        loadItems()
    }
    func addingData(data: Item) {
        expenseArray.append(data)
        saveItems()
        tableView.reloadData()
        calculateTotal()
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
            print ("Error fetching request \(error)")
        }
    }
    func deselectButtons(){
        let intervalButtons = [dailyButton, weeklyButton, monthlyButton, yearlyButton]
        intervalButtons.forEach {
            $0?.backgroundColor = accentColor
            $0?.isSelected = false }
    }
    
    @IBAction func chooseInterval(_ sender: UIButton) {
        self.view.endEditing(true)
        deselectButtons()
        sender.isSelected = true
        if sender.isSelected == true {
            sender.backgroundColor = .white
            print(sender.tag)
            choosenInterval = chooseInterval[sender.tag] ?? 0
            calculateTotal()
        } else {
            sender.backgroundColor = accentColor
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
        cell.detailTextLabel?.text = String(expenseArray[indexPath.row].cash) + (pickedCurrency ?? " $")
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
            calculateTotal()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        pickedCurrency = defaults.string(forKey: "Currency")
        calculateTotal()
    }
    func calculateTotal(){
            totalAmount = 0
            for cash in expenseArray {
                let amount = cash.value(forKey: "perday") as! Double
                totalAmount += amount
                print(totalAmount)
                totalNumber.text = String(format:"%.2f",totalAmount*Double(choosenInterval)) + (pickedCurrency ?? " $")
        }
    }
    
}
