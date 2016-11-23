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
        let tipPercentages = [0.15, 0.2, 0.25]
        let amount = Double(amountField.text!) ?? 0.0
        let tip = amount * tipPercentages[tipControl.selectedSegmentIndex]
        let total = amount + tip
        
        tipLabel.text = String(format: "$%.2llf", tip)
        totalLabel.text = String(format: "$%.2llf", total)
    }
}

