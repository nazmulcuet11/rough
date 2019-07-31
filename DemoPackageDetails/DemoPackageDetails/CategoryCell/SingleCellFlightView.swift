//
//  SingleCellFlightView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 7/30/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class SingleCellFlightView: UIView {
    @IBOutlet weak var flightLogo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
