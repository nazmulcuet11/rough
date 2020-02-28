//
//  BookingVC.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import UIKit

class BookingVC: UIViewController {

    @IBOutlet weak var searchStrLabel: UILabel!
    @IBOutlet weak var hotelIdLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!

    var viewModel: HotelBookingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hotel Booking"
        setupScene()
    }

    private func setupScene() {
        searchStrLabel.text = viewModel.searchStr
        hotelIdLabel.text = viewModel.hotelId
        hotelNameLabel.text = viewModel.hotelName
    }
}
