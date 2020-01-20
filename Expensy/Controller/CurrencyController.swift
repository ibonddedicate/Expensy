//
//  CurrencyController.swift
//  Expensy
//
//  Created by Surote Gaide on 19/1/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CurrencyCell"
private let itemsPerRow: CGFloat = 3
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
let currencyArray = ["dollar","baht","euro","yen","rupee","dong","ruble","sterling"]
let currencySign = [" $"," ฿", " €", " ¥", " ₹", " ₫", " ₽", " £"]
let defaults = UserDefaults.standard
var pickedCurrency = defaults.string(forKey: "Currency")

class CurrencyController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return currencyArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CurrencySignCell
    
        
        cell.currencySignImage.image = UIImage(systemName: "\(currencyArray[indexPath.row])sign.square.fill")
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow

      return CGSize(width: widthPerItem, height: widthPerItem)
    }


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defaults.set(currencySign[indexPath.row], forKey: "Currency")
        print("\(currencySign[indexPath.row]) was selected.")
        navigationController?.popViewController(animated: true)

    }

}
