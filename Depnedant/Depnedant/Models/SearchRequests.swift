//
//  SearchRequests.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation

struct SearchRequest {
    var searchStr: String
    var checkinDate: Date
    var checkoutDate: Date
    var roomQueries: [RoomQuery]
}

struct RoomQuery {
    let numberOfAdult: Int
    let numberOfChild: Int
}
