//
//  JTCalendarHeader.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit
import JTAppleCalendar

class JTCalendarHeader: JTACMonthReusableView {

    @IBOutlet weak var monthLabel: UILabel!

    @IBOutlet weak var dayOneLabel: UILabel!
    @IBOutlet weak var dayTwoLabel: UILabel!
    @IBOutlet weak var dayThreeLabel: UILabel!
    @IBOutlet weak var dayFourLabel: UILabel!
    @IBOutlet weak var dayFiveLabel: UILabel!
    @IBOutlet weak var daySixLabel: UILabel!
    @IBOutlet weak var daySevenLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(monthStr: String) {
        monthLabel.text = monthStr
    }

    private let headerFormatter = DateFormatter()
    func configure(startingDateOfTheMonth: Date) {
        headerFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = headerFormatter.string(from: startingDateOfTheMonth)
    }
}
