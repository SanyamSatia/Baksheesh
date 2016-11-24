//
//  ViewController.swift
//  Baksheesh
//
//  Created by Sanyam Satia on 11/23/16.
//  Copyright © 2016 Sanyam Satia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        let tipPercentages: [Float] = [0.15, 0.2, 0.25]
        var tipPercentage = tipSlider.value
        if sender is UISegmentedControl {
            tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
            tipSlider.setValue(Float(tipPercentage), animated: true)
        }
        else if sender is UISlider {
            let position = tipPercentages.index(of: tipSlider.value)
            if(position != nil) {
                tipPercentage = tipPercentages[position!]
            }
            else {
                tipControl.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        }
        
        let amount = Float(amountField.text!) ?? 0.0
        let tip = amount * tipPercentage
        let total = amount + tip
        
        tipLabel.text = String(format: "$%.2lf", tip)
        totalLabel.text = String(format: "$%.2lf", total)
        tipPercentageLabel.text = String(format: "%.2lf%%", tipPercentage * 100)
    }
}

