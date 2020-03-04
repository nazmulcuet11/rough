//
//  HomeVC.swift
//  ConfigurableCalendar
//
//  Created by Nazmul Islam on 4/3/20.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectSingleDate(_ sender: Any) {
        let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(JTCalendarVC.self)") as! JTCalendarVC
        calendarVC.configure(dateSelectionMode: .single)
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @IBAction func selectDateRange(_ sender: Any) {
        let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(JTCalendarVC.self)") as! JTCalendarVC
        calendarVC.configure(dateSelectionMode: .range)
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @IBAction func selectDateRangeAllowingSingleDate(_ sender: Any) {
        let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(JTCalendarVC.self)") as! JTCalendarVC
        calendarVC.configure(dateSelectionMode: .range, singleDateAllowedDuringRangeSelection: true)
        navigationController?.pushViewController(calendarVC, animated: true)
    }
}
