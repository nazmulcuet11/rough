//
//  ViewController.swift
//  DemoPackageDetails
//
//  Created by Nazmul Islam on 31/7/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell =  UITableViewCell()

            let priceView = Bundle.main.loadNibNamed("TopCellPriceView", owner: self, options: nil)?.first as! TopCellPriceView
            priceView.configure(priceStr: "BDT 1050", priceAfterDiscount: nil, discountPercentage: nil)
            cell.contentView.addSubview(priceView)

            let shareView = Bundle.main.loadNibNamed("SingleCellShareView", owner: self, options: nil)?.first as! SingleCellShareView
            shareView.confugure()
            cell.contentView.addSubview(shareView)

            let tripCoinView = Bundle.main.loadNibNamed("SingleCellTripCoinView", owner: self, options: nil)?.first as! SingleCellTripCoinView
            tripCoinView.configure(earnedTripCoin: 200, redeemedTripCoin: 200)
            cell.contentView.addSubview(tripCoinView)

            priceView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            priceView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            priceView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            //        priceView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true

            tripCoinView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive =  true
            tripCoinView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive =  true
            tripCoinView.topAnchor.constraint(equalTo: priceView.bottomAnchor).isActive = true
            //        tripCoinView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive =  true
            //        tripCoinView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true

            shareView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive =  true
            shareView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive =  true
            //        shareView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive =  true
            shareView.topAnchor.constraint(equalTo: tripCoinView.bottomAnchor).isActive =  true
            shareView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive =  true

            print(shareView.frame.height)
            print(tripCoinView.frame.height)

            print(shareView.bounds.height)
            print(tripCoinView.bounds.height)

            return cell
        } else {
            let cell = UITableViewCell()
            let contentView = cell.contentView

            let headerView = Bundle.main.loadNibNamed("CategoryCellHeaderView", owner: self, options: nil)?.first as! CategoryCellHeaderView
            headerView.configure()
            contentView.addSubview(headerView)

            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true


            let hotelStack = UIStackView()
            hotelStack.axis = .vertical
            hotelStack.alignment = .top
            hotelStack.distribution = .fillEqually
            hotelStack.translatesAutoresizingMaskIntoConstraints = false

            for _ in 0..<5 {
                let hotelView = Bundle.main.loadNibNamed("SingleCellHotelView", owner: self, options: nil)?.first as! SingleCellHotelView
                hotelView.heightAnchor.constraint(equalToConstant: 28).isActive = true
                print(hotelView.bounds.height)
                hotelStack.addArrangedSubview(hotelView)
            }
            contentView.addSubview(hotelStack)

            hotelStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            hotelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            hotelStack.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            hotelStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

            return cell
        }

    }


}

