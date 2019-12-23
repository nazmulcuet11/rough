//
//  DatePickerViewController.swift
//  HomePwner
//
//  Created by Nazmul Islam on 27/5/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.date = item.dateCreated
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        item.dateCreated = datePicker.date
    }
}
