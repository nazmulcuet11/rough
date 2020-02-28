//
//  HotelDetailViewModel.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation

protocol HotelDetailViewModel {
    var id: String { get }
    var name: String { get }
    var address: String { get }
    var rating: Int { get }
    var city: String { get }
    var country: String { get }
    var policy: String { get }

    func loadHotelDetail(onCompletion: @escaping () -> Void)
}

class DefaultHotelDetailViewModel: HotelDetailViewModel {
    var id: String { return detail?.id ?? "" }
    var name: String { return detail?.name ?? "" }
    var address: String { return detail?.address ?? "" }
    var rating: Int { return detail?.rating ?? 0 }
    var city: String { return detail?.city ?? "" }
    var country: String { return detail?.country ?? "" }
    var policy: String { return detail?.policy ?? "" }

    private let service: HotelService
    private let hotelId: String
    init(service: HotelService, hotelId: String) {
        self.service = service
        self.hotelId = hotelId
    }

    private var detail: HotelDetail?
    func loadHotelDetail(onCompletion: @escaping () -> Void) {
        service.getHotelDetail(id: hotelId, onSuccess: { [weak self] hotelDetail in
            self?.detail = hotelDetail
            onCompletion()
        }, onFailure: { error in
            print(error)
            onCompletion()
        })
    }
}
