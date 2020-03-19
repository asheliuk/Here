//
//  GeocodeResponse.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public struct GeocodeResponse: Decodable {

    public private(set) var addresses: [Address]

    // MARK: - Decodable
    public init(from decoder: Decoder) throws {
        addresses = []
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        var viewsContainer = try responseContainer.nestedUnkeyedContainer(forKey: .view)

        while !viewsContainer.isAtEnd {
            let viewContainer = try viewsContainer.nestedContainer(keyedBy: CodingKeys.self)
            var resultContainer = try viewContainer.nestedUnkeyedContainer(forKey: .result)

            while !resultContainer.isAtEnd {
                let result = try resultContainer.nestedContainer(keyedBy: CodingKeys.self)
                let locationContainer = try result.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
                let address = try locationContainer.decode(Address.self, forKey: .address)

                addresses.append(address)
            }
        }
    }

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case response = "Response", view = "View", result = "Result", location = "Location", address = "Address"
    }
}
