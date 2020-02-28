//
//  HotelListViewModel.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation

protocol HotelListViewModel {
    var hotelCount: Int { get }
    func getHotel(at index: Int) -> Hotel?
    func loadHotels(onCompletion: @escaping ()-> Void)
    func updateSearchRequest(searchRequest: SearchRequest)
}

class DefaultHotelListViewModel: HotelListViewModel {
    private var hotels = [Hotel]()

    private let service: HotelService
    private var searchRequest: SearchRequest
    init(service: HotelService, searchRequest: SearchRequest) {
        self.service = service
        self.searchRequest = searchRequest
    }

    var hotelCount: Int { return hotels.count }

    func getHotel(at index: Int) -> Hotel? {
        guard 0 <= index && index < hotels.count  else {
            return nil
        }

        return hotels[index]
    }

    func loadHotels(onCompletion: @escaping () -> Void) {
        service.getHotelList(searchRequest: searchRequest, onSuccess: { [weak self] hotels in
            self?.hotels = hotels
            onCompletion()
        }, onFailure: { error in
            print(error)
            onCompletion()
        })
    }

    func updateSearchRequest(searchRequest: SearchRequest) {
        self.searchRequest = searchRequest
    }
}
