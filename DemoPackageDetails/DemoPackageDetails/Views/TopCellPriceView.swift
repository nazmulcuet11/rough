//
//  TopCellPriceView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 7/30/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class TopCellPriceView: UIView {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceAfterDiscountLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!

    func configure(priceStr: String, priceAfterDiscount: String?, discountPercentage: String?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.text = priceStr
        if let priceAfterDiscount = priceAfterDiscount, let discountPercentage = discountPercentage {
            priceAfterDiscountLabel.text = priceAfterDiscount
            discountLabel.text = discountPercentage
        } else {
            priceAfterDiscountLabel.isHidden = true
            priceAfterDiscountLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            discountLabel.isHidden = true
            discountLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
}
