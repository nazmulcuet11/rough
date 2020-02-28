//
//  HotelService.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation

protocol HotelService {
    func getHotelList(searchRequest: SearchRequest,
                      onSuccess: @escaping ([Hotel]) -> Void,
                      onFailure: @escaping (String) -> Void)
    func getHotelDetail(id: String,
                        onSuccess: @escaping (HotelDetail) -> Void,
                        onFailure: @escaping (String) -> Void)
}

class DefaultHotelService: HotelService {
    private var searchedHotels = [Hotel]()
    let serviceQueue = DispatchQueue(label: "Hotel.Service.Queue")

    init() { }

    func getHotelList(searchRequest: SearchRequest, onSuccess: @escaping ([Hotel]) -> Void, onFailure: @escaping (String) -> Void) {
        serviceQueue.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.searchedHotels.removeAll()
            for i in 1...10 {
                let hotel = Hotel(
                    id: "ID\(i)",
                    name: "\(searchRequest.searchStr) Hotel \(i)",
                    address: "Address \(i)",
                    rating: (i % 5) + 1
                )
                self.searchedHotels.append(hotel)
            }
            onSuccess(self.searchedHotels)
        }
    }

    func getHotelDetail(id: String, onSuccess: @escaping (HotelDetail) -> Void, onFailure: @escaping (String) -> Void) {
        serviceQueue.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            guard let hotel = self.searchedHotels.filter({ $0.id == id }).first else {
                onFailure("Hotel with given id not found")
                return
            }

            let detail = HotelDetail(
                id: hotel.id,
                name: hotel.name,
                address: hotel.address,
                rating: hotel.rating,
                city: "Dhaka",
                country: "Bangladesh",
                policy: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
            )

            onSuccess(detail)
        }
    }
}
