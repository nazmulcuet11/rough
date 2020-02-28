//
//  DetailVC.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!

    var viewModel: HotelDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hotel Detail"

        viewModel.loadHotelDetail {
            DispatchQueue.main.async { [weak self] in
                self?.setupSceneWithData()
            }
        }
    }

    func setupSceneWithData() {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        ratingLabel.text = "\(viewModel.rating)"
        cityLabel.text = viewModel.city
        countryLabel.text = viewModel.country
        policyLabel.text = viewModel.policy
    }

    @IBAction func onBookNowButtonTapped(_ sender: Any) {
        let hotelContainer = AppManager.shared.hotelContainer
        let bookingViewModel = hotelContainer.resolve(HotelBookingViewModel.self, argument: viewModel.id)!
        let bookingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "\(BookingVC.self)") as BookingVC
        bookingVC.viewModel = bookingViewModel

        navigationController?.pushViewController(bookingVC, animated: true)
    }
}
