//
//  CategoryCellHeaderView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 7/30/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class CategoryCellHeaderView: UIView {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var airfareLabel: UILabel!
    @IBOutlet weak var departsLabel: UILabel!
    @IBOutlet weak var periodFromLabel: UILabel!
    @IBOutlet weak var periodToLabel: UILabel!

    func configure()  {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
