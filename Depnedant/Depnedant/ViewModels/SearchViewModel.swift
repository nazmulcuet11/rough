//
//  SearchViewModel.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation

protocol SearchViewModel {
    var searchStr: String { get set }
    var checkinDate: Date { get set }
    var checkoutDate: Date { get set }
    var roomQueries: [RoomQuery] { get set }

    func getSearchRequest() -> SearchRequest
}

class DefaultSearchViewModel: SearchViewModel {
    var searchStr: String {
        get { searchRequest.searchStr }
        set {
            searchRequest.searchStr = newValue
        }
    }
    var checkinDate: Date {
        get { searchRequest.checkinDate }
        set {
            searchRequest.checkinDate = newValue
        }
    }
    var checkoutDate: Date {
        get { searchRequest.checkoutDate }
        set {
            searchRequest.checkoutDate = newValue
        }
    }
    var roomQueries: [RoomQuery] {
        get { searchRequest.roomQueries }
        set {
            searchRequest.roomQueries = newValue
        }
    }

    private var searchRequest: SearchRequest
    init(searchRequest: SearchRequest) {
        self.searchRequest = searchRequest
    }

    func getSearchRequest() -> SearchRequest {
        return searchRequest
    }
}
