//
//  ObjectScope+Extensions.swift
//  Depnedant
//
//  Created by Nazmul Islam on 15/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import Foundation
import Swinject

extension ObjectScope {
    static let hotelScope = ObjectScope(storageFactory: PermanentStorage.init,
                                   description: "DiscardedWhenNewHotelSearchBeganFromDashboard")
}
