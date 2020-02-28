//
//  AppManager.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation
import Swinject

class AppManager {
    private static var sharedInstance: AppManager?
    static var shared: AppManager {
        guard sharedInstance == nil else {
            return sharedInstance!
        }

        sharedInstance = AppManager()
        return sharedInstance!
    }

    func destroy() {
        AppManager.sharedInstance = nil
    }

    private(set) var hotelContainer = Container()
    private init() {
        hotelContainer.register(HotelService.self) { resolver in
            return DefaultHotelService()
        }.inObjectScope(.hotelScope)

        hotelContainer.register(SearchRequest.self) { resolver in
            return SearchRequest(
                searchStr: "",
                checkinDate: Date(),
                checkoutDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                roomQueries: [RoomQuery]()
            )
        }.inObjectScope(.hotelScope)

        hotelContainer.register(SearchViewModel.self) { resolver in
            let searchRequest = resolver.resolve(SearchRequest.self)!
            return DefaultSearchViewModel(searchRequest: searchRequest)
        }.inObjectScope(.hotelScope)

        hotelContainer.register(HotelListViewModel.self) { resolver in
            let service = resolver.resolve(HotelService.self)!
            let searchViewModel = resolver.resolve(SearchViewModel.self)!
            let searchRequest = searchViewModel.getSearchRequest()
            return DefaultHotelListViewModel(service: service, searchRequest: searchRequest)
        }.inObjectScope(.hotelScope)

        hotelContainer.register(HotelDetailViewModel.self) { (resolver: Resolver, hotelId: String) in
            let service = resolver.resolve(HotelService.self)!
            return DefaultHotelDetailViewModel(service: service, hotelId: hotelId)
        }.inObjectScope(.hotelScope)

        hotelContainer.register(HotelBookingViewModel.self) { (resolver: Resolver, hotelId: String) in
            let searchViewModel = resolver.resolve(SearchViewModel.self)!
            let searchRequest = searchViewModel.getSearchRequest()
            let hotelDetailViewModel = resolver.resolve(HotelDetailViewModel.self, argument: hotelId)!
            return DefaultHotelBookingViewModel(searchStr: searchRequest.searchStr,
                                                hotelId: hotelDetailViewModel.id,
                                                hotelName: hotelDetailViewModel.name)
        }.inObjectScope(.hotelScope)
    }
}
