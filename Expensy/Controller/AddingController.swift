//
//  AddingController.swift
//  Expensy
//
//  Created by Surote Gaide on 12/1/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import UIKit
import CoreData

protocol AddingDelegate {
    func addingData(data: Item)
}

class AddingController : UIViewController, UITextFieldDelegate {
    
    var delegate: AddingDelegate?
    let chooseInterval = [1:1,2:7,3:30,4:365]
    var costInterval = 0
    let accentColor = UIColor(red: 132/255.0, green: 196/255.0, blue: 103/255.0, alpha: 1)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var expenseTitle: UITextField!
    @IBOutlet weak var costTitle: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = doneButton.frame.size.height/2
        dailyButton.layer.cornerRadius = dailyButton.frame.size.height/2
        weeklyButton.layer.cornerRadius = weeklyButton.frame.size.height/2
        monthlyButton.layer.cornerRadius = monthlyButton.frame.size.height/2
        yearlyButton.layer.cornerRadius = yearlyButton.frame.size.height/2
        expenseTitle.delegate = self
        costTitle.placeholder = "The cost.. (eg. 15 \(pickedCurrency ?? " $"))"
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        if expenseTitle.text != "" && costTitle.text != "" && costInterval != 0{
            let newItem = Item(context: context)
            newItem.expenseTitle = expenseTitle.text
            newItem.cash  = Double(costTitle.text!)!
            newItem.interval = Double(costInterval)
            newItem.perday = Double(costTitle.text!)! / Double(costInterval)
            
            delegate?.addingData(data: newItem)
            dismiss(animated: true, completion: nil)
            print(newItem.perday)
        } else {
            print("Textbox empty")
        }
    }
    
    func deselectButtons(){
        let intervalButtons = [dailyButton, weeklyButton, monthlyButton, yearlyButton]
        intervalButtons.forEach {
            $0?.backgroundColor = accentColor
            $0?.isSelected = false }
    }
    
    @IBAction func chosenInterval(_ sender: UIButton) {
        self.view.endEditing(true)
        deselectButtons()
        sender.isSelected = true
        if sender.isSelected == true {
            sender.backgroundColor = .white
            costInterval = chooseInterval[sender.tag] ?? 0
            print(costInterval)
        } else {
            sender.backgroundColor = accentColor
            costInterval = 0
        }
        
        doneButtonTurnsBright()
    }
    
    func doneButtonTurnsBright() {
        if expenseTitle.text != "" && costTitle.text != "" && costInterval != 0 {
            doneButton.backgroundColor = .white
        } else {
            doneButton.backgroundColor = accentColor
        }
    }
    
    
//- dismissing keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        doneButtonTurnsBright()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
        doneButtonTurnsBright()
       }

}
