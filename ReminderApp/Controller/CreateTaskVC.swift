//
//  CreateTaskVC.swift
//  ReminderApp
//
//  Created by Ondřej Svojše on 03.12.17.
//  Copyright © 2017 Ondřej Svojše. All rights reserved.
//

import UIKit
import CoreData


class CreateTaskVC: UIViewController, UITextFieldDelegate {
    
    var note: String!
    var deadlineDate: String!
   
    @IBOutlet weak var createTaskBtn: UIButton!
    @IBOutlet weak var taskText: UITextField!
    
    @IBOutlet weak var taskContent: UITextField!
    @IBOutlet weak var dateTextLbl: UITextView!
    
    @IBOutlet var createTaskView: UIView!
    
    // Add Task button
    @IBAction func addTask(_ sender: Any) {
        if taskContent.text != "" && dateTextLbl.text! != "Select deadline ..." {
        self.save { (complete) in
            if complete {
                dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // moves the view up when keyboard activated
        createTaskView.bindToKeyboard()
        taskContent.delegate = self
        DatePicker()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // Date picker implementation
    let datePicker = UIDatePicker()
    func DatePicker() {
        
        datePicker.locale = NSLocale(localeIdentifier: "cs-CZ") as Locale!
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneButton], animated: false)
        
        dateTextLbl.inputAccessoryView = toolbar
        dateTextLbl.inputView = datePicker
        
        print(datePicker.date)
        
        
    }
    // StackOverflow
    @objc func donePressed() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en-GB") as Locale!
        // Convert date to string
        dateTextLbl.text! = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
        
    }
    
    // https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
    // Dissmiss the keyboard on tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        taskText.selectedTextRange = nil // ensures no text is selected, avoiding an issue which prevented single-tapping on the text after keyboard dismisses
        view.endEditing(true) // dismisses keyboard
    }
    // 
    

    
    
    // Saving Data to CoreData
    func save(completion: (_ finished: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let task = Task(context: managedContext)
        task.note = taskContent.text!
        task.deadlineDate = dateTextLbl.text!
        
        do {
            try managedContext.save()
            print("Success")
            completion(true)
            
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        dismiss(animated: true, completion: nil)
        
        
    }
    

}



// https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
extension UIView {
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endingFrame.origin.y - startingFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    
    
}
