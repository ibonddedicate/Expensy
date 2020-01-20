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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var expenseTitle: UITextField!
    @IBOutlet weak var costTitle: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = 27.0
        expenseTitle.delegate = self
        costTitle.placeholder = "The cost.. (eg. 15 \(pickedCurrency ?? " $"))"
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        if expenseTitle.text != "" && costTitle.text != ""{
            let newItem = Item(context: context)
            newItem.expenseTitle = expenseTitle.text
            newItem.cash  = Double(costTitle.text!)!
            delegate?.addingData(data: newItem)
        } else {
            print("Textbox empty")
        }
        dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }

}
