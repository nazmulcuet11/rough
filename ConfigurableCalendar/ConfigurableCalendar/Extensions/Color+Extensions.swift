//
//  Color+Extensions.swift
//  ConfigurableCalendar
//
//  Created by Nazmul Islam on 4/3/20.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(redInt: Int, greenInt: Int, blueInt: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(redInt) / 255.0,
            green: CGFloat(greenInt) / 255.0,
            blue: CGFloat(blueInt) / 255.0,
            alpha: alpha
        )
    }

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            redInt: (hex >> 16) & 0xFF,
            greenInt: (hex >> 8) & 0xFF,
            blueInt: hex & 0xFF,
            alpha: alpha
        )
    }

    static var clearBlue: UIColor {
        return UIColor(hex: 0x1882FF)
    }
}
