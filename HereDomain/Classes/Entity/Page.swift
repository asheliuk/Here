//
//  Page.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public struct Page<T>: Decodable where T: Decodable {

    public let next: URL?
    public let prev: URL?
    public let items: [T]
}

struct ResultsResponse<T: Decodable>: Decodable {

    let results: T
}
