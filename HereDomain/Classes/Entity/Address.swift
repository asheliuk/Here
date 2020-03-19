//
//  Address.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public struct Address: Decodable {

    public let title: String

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case title = "Label"
    }
}
