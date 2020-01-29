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
    let chooseInterval = [1:365,2:52,3:12,4:1]
    var costInterval = 0
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
        if expenseTitle.text != "" && costTitle.text != ""{
            let newItem = Item(context: context)
            newItem.expenseTitle = expenseTitle.text
            newItem.cash  = Double(costTitle.text!)!
            newItem.interval = Double(costInterval)
            
            delegate?.addingData(data: newItem)
            
        } else {
            print("Textbox empty")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func chosenInterval(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        costInterval = chooseInterval[sender.tag] ?? 0
        sender.backgroundColor = .white
    }
    
    
    
    
//- dismissing keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }

}
