//
//  SingleCellTripCoinView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 7/30/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class SingleCellTripCoinView: UIView {
    @IBOutlet weak var earnedTripCoinLabel: UILabel!
    @IBOutlet weak var redeemTripCoinLabel: UILabel!

    func configure(earnedTripCoin: Int, redeemedTripCoin: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        earnedTripCoinLabel.text = earnedTripCoin.description
        redeemTripCoinLabel.text = redeemedTripCoin.description
    }
}
