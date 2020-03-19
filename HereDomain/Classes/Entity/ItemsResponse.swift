//
//  ItemsResponse.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

struct ItemsResponse<T>: Decodable where T: Decodable  {

    let items: [T]
}
