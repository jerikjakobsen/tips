//
//  ViewController.swift
//  Codepath Tips
//
//  Created by John Jakobsen on 7/14/20.
//  Copyright © 2020 John Jakobsen. All rights reserved.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var taxRateLabel: UILabel!
    @IBOutlet weak var totalTip: UILabel!
    @IBOutlet weak var totalTax: UILabel!
    @IBOutlet weak var tipPercentageSlider: UISlider!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    var amount: String = "0.0"
    var tax: Double = 0.0
    var stateRow = 0
    var backgroundColorVal:Float = 0.0
    var keyboardColor: Float = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromDisk()
        billAmountChanged()
        // Do any additional setup after loading the view.
        self.title = "Billculator"
    }
    func saveDataToDisk() {
        //Save User entered amount
        UserDefaults.standard.set(amountToDouble(), forKey: "userAmount")
        //Save Tax selected
        UserDefaults.standard.set(tax, forKey: "tax")
        //Save background color
        UserDefaults.standard.set(backgroundColorVal, forKey: "backgroundColor")
        //Save keyboard Color
        print("Keyboard Color Value: ", keyboardColor)
        UserDefaults.standard.set(keyboardColor, forKey: "keyboardColor")
        //Save State Selected
        UserDefaults.standard.set(stateRow, forKey: "stateRow")
        UserDefaults.standard.set(NSDate.now, forKey: "date")
        UserDefaults.standard.set(tipPercentageSlider.value, forKey: "tip")
    }
    func configureColors(type: String, value: Float) {
        var red: Float = 0, blue:Float = 0, green: Float = 0
        if value <= 0.5 {
            red = 1 - value * 2
            if value >= 0.33 {
                blue = (value - 0.33) * 5.88
            }
        }

        if value > 0.5 {
            if value <= 0.66 {
                blue = 1 - (value - 0.5) * 5.88
            }
            green = (value - 0.5) * 2
        }
        let r = CGFloat(red)
        let b = CGFloat(blue)
        let g = CGFloat(green)
        if type == "keyboard" {
            keyboardButtons.forEach { (UIButton) in
                UIButton.backgroundColor = UIColor.init(red: r, green: g, blue: b, alpha: 1)
            }
        } else {
            self.view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        }
    }
    func readFromDisk() {
        if let tip2 = UserDefaults.standard.object(forKey: "tip") {
            tipPercentageSlider.value = tip2 as! Float
        }
        if let date = UserDefaults.standard.object(forKey: "date") {
            let date2 = date as! NSDate
            if date2.addingTimeInterval(60 * 5).compare(Date()) == ComparisonResult.orderedAscending {
                return
            }
        }
        if let userAmount = UserDefaults.standard.object(forKey: "userAmount") {
            
            billAmount.text = userAmount as! Double == 0.0 ? "0.00" : String(userAmount as! Double)
            amount = billAmount.text!
        }
        if let selectedStateRow = UserDefaults.standard.object(forKey: "stateRow") {
            stateRow = selectedStateRow as! Int
        }
        if let savedTax = UserDefaults.standard.object(forKey: "tax") {
            tax = savedTax as! Double
            updateTax(newtax: tax, row: stateRow)
        }
        if let backgroundColor = UserDefaults.standard.object(forKey: "backgroundColor") {
            backgroundColorVal = backgroundColor as! Float
            configureColors(type: "background", value: backgroundColorVal)
        }
        if let keyboardColorval = UserDefaults.standard.object(forKey: "keyboardColor") {
            keyboardColor = keyboardColorval as! Float
            configureColors(type: "keyboard", value: keyboardColor)
        }
    }
    func delete() {
        if amount == "" || billAmount.text == "0.00"{
            return
        }

        if (amount.count == 1 || billAmount.text == "0") {
            billAmount.text = "0.00"
            amount = ""
            return
        }
        amount = String(amount.prefix(amount.count-1))
        if (amount == "0") {
            amount = "0.00"
        }
        billAmount.text = amount
        saveDataToDisk()
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        delete()
        billAmountChanged(sender)
    }
    
    
    @IBAction func keyboardDidTap(_ sender: Any) {
        let send = sender as! UIButton
        let title = send.currentTitle!
        if billAmount.text!.contains(".") && billAmount.text!.last! != "." {
            if billAmount.text!.split(separator: ".")[1].count == 2  && billAmount.text! != "0.00" {
                return
            }
        }
        if title == "." && billAmount.text!.contains(".") {
            return
        }
        if (title == "0" && billAmount.text == "0.00" ) {
            return
        }
        if (title != "0" && billAmount.text == "0.00") {
            amount = ""
        }
        amount += send.currentTitle!
        billAmount.text = amount
        billAmountChanged(sender)
    }
    
    @IBAction func didTapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    func amountToDouble() -> Double {
        if billAmount.text == "0." {
            return 0.00
        }
        if billAmount.text!.last! == "." {
            return Double(billAmount.text!.prefix(billAmount.text!.count-1)) ?? 0
        }
        return Double(billAmount.text!) ?? 0
        
    }
    func billAmountChanged() {
        let billAmountDouble = amountToDouble()
        let tip = billAmountDouble * Double(tipPercentageSlider.value)
        tipPercentageLabel.text = String(format: "%.2f%%", tipPercentageSlider.value * 100)
        totalTip.text = String(format:"$ %.2f", tip)
        totalAmount.text = String(format: "$ %.2f", billAmountDouble + tip + (tax/100) * billAmountDouble)
        totalTax.text = String(format: "$ %.2f", tax * amountToDouble() / 100)
    }
    @IBAction func billAmountChanged(_ sender: Any) {
        billAmountChanged()
        saveDataToDisk()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsController = segue.destination as! SettingsViewController
        settingsController.mainController = self
        settingsController.selectedRow = stateRow
        settingsController.selectedTax = tax
        settingsController.backgroundColorValue = backgroundColorVal
        settingsController.keyboardColor = keyboardColor
        
    }
    
    func updateTax(newtax: Double, row: Int) {
        stateRow = row
        tax = newtax
        taxRateLabel.text = String(format: "%.2f %%", tax)
        totalTax.text = String(format: "$ %.2f", tax * amountToDouble() / 100)
        billAmountChanged()
    }
    
    func setBackground(color: UIColor, colorVal: Float) {
        backgroundColorVal = colorVal
        self.view.backgroundColor = color
        saveDataToDisk()
    }
    @IBOutlet var keyboardButtons: [UIButton]!
    func setKeyboardColor(color: UIColor, colorVal: Float) {
        keyboardButtons.forEach { (UIButton) in
            UIButton.backgroundColor = color
        }
        keyboardColor = colorVal
        saveDataToDisk()
    }
}

