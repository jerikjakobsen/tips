//
//  SettingsViewController.swift
//  Codepath Tips
//
//  Created by John Jakobsen on 7/17/20.
//  Copyright © 2020 John Jakobsen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var colorSlider: UISlider!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsViewController.states.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SettingsViewController.states[row]
    }
    
    
    static let states:[String] = [
        "",
    "California",
    "Indiana",
    "Mississippi",
    "Rhode Island",
    "Tennessee",
    "Minnesota",
    "Nevada",
    "New Jersey",
    "Arkansas",
    "Kansas",
    "Washington",
    "Connecticut",
    "Illinois",
    "Massachusetts",
    "Texas",
    "Florida",
    "Idaho",
    "Iowa",
    "Kentucky",
    "Maryland",
    "Michigan",
    "Pennsylvania",
    "South Carolina",
    "Vermont",
    "West Virginia",
    "Utah",
    "Ohio",
    "Arizona",
    "Maine",
    "Nebraska",
    "Virginia",
    "New Mexico",
    "North Dakota",
    "Wisconsin",
    "North Carolina",
    "Oklahoma",
    "South Dakota",
    "Louisiana",
    "Missouri",
    "Alabama",
    "Georgia",
    "Hawaii",
    "New York",
    "Wyoming",
    "Colorado",
    "Alaska",
    "Delaware",
    "Montana",
    "New Hampshire",
    "Oregon",
    ]
    
    static let stateTaxes:[String: Double] = [
    "California": 8.56,
    "Indiana": 7.0,
    "Mississippi": 7.07,
    "Rhode Island": 7.0,
    "Tennessee": 9.47,
    "Minnesota": 7.43,
    "Nevada": 8.14,
    "New Jersey": 6.6,
    "Arkansas": 9.43,
    "Kansas": 8.67,
    "Washington": 9.17,
    "Connecticut": 6.35,
    "Illinois": 8.74,
    "Massachusetts": 6.25,
    "Texas": 8.19,
    "Florida": 7.05,
    "Idaho": 6.03,
    "Iowa": 6.82,
    "Kentucky": 6.0,
    "Maryland": 6.0,
    "Michigan": 6.0,
    "Pennsylvania": 6.34,
    "South Carolina": 7.43,
    "Vermont": 6.18,
    "West Virginia": 6.39,
    "Utah": 6.94,
    "Ohio": 7.17,
    "Arizona": 8.37,
    "Maine": 5.5,
    "Nebraska": 6.85,
    "Virginia": 5.65,
    "New Mexico": 7.82,
    "North Dakota": 6.85,
    "Wisconsin": 5.44,
    "North Carolina": 6.97,
    "Oklahoma": 8.92,
    "South Dakota": 6.4,
    "Louisiana": 9.45,
    "Missouri": 8.13,
    "Alabama": 9.14,
    "Georgia": 7.29,
    "Hawaii": 4.41,
    "New York": 8.49,
    "Wyoming": 5.36,
    "Colorado": 7.63,
    "Alaska": 1.43,
    "Delaware": 0.0,
    "Montana": 0.0,
    "New Hampshire": 0.0,
    "Oregon": 0.0,
    ]
    var selectedTax: Double = 0.0
    var selectedRow: Int = 0
    var backgroundColorValue: Float = 0.0
    var keyboardColor: Float = 0.0
    @IBOutlet weak var stateLabel: UILabel!
    var mainController: ViewController!
    
    
    @IBOutlet weak var keyboardColorSliderOutlet: UISlider!
    @IBOutlet weak var statePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statePicker.delegate = self
        self.statePicker.dataSource = self
        
        statePicker.selectRow(selectedRow, inComponent: 0, animated: false)
        colorSlider.value = backgroundColorValue
        keyboardColorSliderOutlet.value = keyboardColor
        // background color init
        var red: Float = 0, blue:Float = 0, green: Float = 0
                if colorSlider.value <= 0.5 {
                    red = 1 - colorSlider.value * 2
                    if colorSlider.value >= 0.33 {
                        blue = (colorSlider.value - 0.33) * 5.88
                    }
                }

                if colorSlider.value > 0.5 {
                    if colorSlider.value <= 0.66 {
                        blue = 1 - (colorSlider.value - 0.5) * 5.88
                    }
                    green = (colorSlider.value - 0.5) * 2
                }
                var r = CGFloat(red)
                var b = CGFloat(blue)
                var g = CGFloat(green)
                colorSlider.thumbTintColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                colorSlider.tintColor = colorSlider.thumbTintColor
        // Keyboard Color Init
        red = 0
        blue = 0
        green = 0
        if keyboardColorSliderOutlet.value <= 0.5 {
            red = 1 - keyboardColorSliderOutlet.value * 2
            if keyboardColorSliderOutlet.value >= 0.33 {
                blue = (keyboardColorSliderOutlet.value - 0.33) * 5.88
            }
        }

        if keyboardColorSliderOutlet.value > 0.5 {
            if keyboardColorSliderOutlet.value <= 0.66 {
                blue = 1 - (keyboardColorSliderOutlet.value - 0.5) * 5.88
            }
            green = (keyboardColorSliderOutlet.value - 0.5) * 2
        }
        r = CGFloat(red)
        b = CGFloat(blue)
        g = CGFloat(green)
        keyboardColorSliderOutlet.thumbTintColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        keyboardColorSliderOutlet.tintColor = keyboardColorSliderOutlet.thumbTintColor
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTax = SettingsViewController.stateTaxes[ SettingsViewController.states[row]] ?? 0.0
        selectedRow = row
    }

    @IBAction func didTapDone(_ sender: Any) {
        mainController.updateTax(newtax: selectedTax, row: selectedRow)
        dismiss(animated: true)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        var red: Float = 0, blue:Float = 0, green: Float = 0
//
        if colorSlider.value <= 0.5 {
            red = 1 - colorSlider.value * 2
            if colorSlider.value >= 0.33 {
                blue = (colorSlider.value - 0.33) * 5.88
            }
        }

        if colorSlider.value > 0.5 {
            if colorSlider.value <= 0.66 {
                blue = 1 - (colorSlider.value - 0.5) * 5.88
            }
            green = (colorSlider.value - 0.5) * 2
        }
        let r = CGFloat(red)
        let b = CGFloat(blue)
        let g = CGFloat(green)
        mainController.setBackground(color: UIColor(red: r, green: g, blue: b, alpha: 1), colorVal: colorSlider.value)
        colorSlider.thumbTintColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        colorSlider.tintColor = colorSlider.thumbTintColor
        backgroundColorValue = colorSlider.value
    }
    @IBAction func keyboardColorSlider(_ sender: Any) {
        var red: Float = 0, blue:Float = 0, green: Float = 0
        if keyboardColorSliderOutlet.value <= 0.5 {
            red = 1 - keyboardColorSliderOutlet.value * 2
            if keyboardColorSliderOutlet.value >= 0.33 {
                blue = (keyboardColorSliderOutlet.value - 0.33) * 5.88
            }
        }

        if keyboardColorSliderOutlet.value > 0.5 {
            if keyboardColorSliderOutlet.value <= 0.66 {
                blue = 1 - (keyboardColorSliderOutlet.value - 0.5) * 5.88
            }
            green = (keyboardColorSliderOutlet.value - 0.5) * 2
        }
        let r = CGFloat(red)
        let b = CGFloat(blue)
        let g = CGFloat(green)
        mainController.setKeyboardColor(color: UIColor(red: r, green: g, blue: b, alpha: 1), colorVal: keyboardColorSliderOutlet.value)
        keyboardColorSliderOutlet.thumbTintColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        keyboardColorSliderOutlet.tintColor = keyboardColorSliderOutlet.thumbTintColor
        keyboardColor = keyboardColorSliderOutlet.value
    }
}
