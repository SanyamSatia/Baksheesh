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

    override func viewDidAppear(_ animated: Bool) {
        amountField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let TIME_INTERVAL = 600.0
        
        // Push up/down view with keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let defaults = UserDefaults.standard
        
        // Set amount field with old amount if:
        // a) app was last closed less than 10 mins ago, and,
        // b) amount retention is enabled
        if defaults.object(forKey: "last_close_time") != nil && (defaults.object(forKey: "amount_save") == nil || defaults.bool(forKey: "amount_save") == true)
        {
            let last_close_time = defaults.object(forKey: "last_close_time") as! Date
            let elapsed_time = Date().timeIntervalSince(last_close_time)
            let amount = defaults.float(forKey: "old_amount")
            
            if elapsed_time <= TIME_INTERVAL && amount != 0.0 {
                amountField.text = String(amount)
            }
        }
        
        // Set tip slider to the default percentage, if set
        if defaults.object(forKey: "default_tip_percentage") != nil {
            tipSlider.setValue(defaults.float(forKey: "default_tip_percentage"), animated: true)
            calculateTip(tipSlider)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        let tipPercentages: [Float] = [0.15, 0.2, 0.25]
        var tipPercentage = tipSlider.value
        
        // Check sender and update other parts appropriately
        if sender is UISegmentedControl {
            tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
            tipSlider.setValue(Float(tipPercentage), animated: true)
        }
        else if sender is UISlider {
            let position = tipPercentages.index(of: tipSlider.value)
            if(position != nil) {
                tipControl.selectedSegmentIndex = position!
            }
            else {
                tipControl.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        }
        
        // Calculate tip and update labels
        let amount = Float(amountField.text!) ?? 0.0
        let tip = amount * tipPercentage
        let total = amount + tip
        
        let defaults = UserDefaults.standard
        defaults.set(tipPercentage, forKey: "current_tip_percentage")
        defaults.set(amount, forKey: "old_amount")
        
        tipLabel.text = String(format: "$%.2lf", tip)
        totalLabel.text = String(format: "$%.2lf", total)
        tipPercentageLabel.text = String(format: "%.2lf%%", tipPercentage * 100)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

