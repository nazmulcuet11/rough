//
//  HotelBooking.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation

protocol HotelBookingViewModel {
    var searchStr: String { get }
    var hotelId: String { get }
    var hotelName: String { get }
}

class DefaultHotelBookingViewModel: HotelBookingViewModel {
    let searchStr: String
    let hotelId: String
    let hotelName: String

    init(searchStr: String, hotelId: String, hotelName: String) {
        self.searchStr = searchStr
        self.hotelId = hotelId
        self.hotelName = hotelName
    }
}
