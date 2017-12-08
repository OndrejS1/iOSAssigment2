//
//  TaskCell.swift
//  ReminderApp
//
//  Created by Ondřej Svojše on 01.12.17.
//  Copyright © 2017 Ondřej Svojše. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    

    @IBOutlet weak var dateLbl: UITextField!
    @IBOutlet weak var txtLbl: UITextView!
    
    
   func configureCell(deadlineDate: String, note: String) {
        
        dateLbl.text = deadlineDate
        txtLbl.text = note
        
    }
    
}
