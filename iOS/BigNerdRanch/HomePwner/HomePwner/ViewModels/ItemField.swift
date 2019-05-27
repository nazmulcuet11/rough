//
//  ItemField.swift
//  HomePwner
//
//  Created by Nazmul Islam on 20/3/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class ItemField: UITextField {
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5.0
        
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        layer.borderColor = UIColor.clear.cgColor
        return true
    }

}
