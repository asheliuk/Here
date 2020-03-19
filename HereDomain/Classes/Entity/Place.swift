//
//  Place.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import CoreLocation

public struct Place: Decodable, Equatable {

    public let id: Id<Place>
    public let title: String
    public let distance: Int
    public let position: CLLocationCoordinate2D
    public let icon: URL
    public let vicinity: String

    // MARK: - Equatable
    public static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CLLocationCoordinate2D: Decodable {

    public init(from decoder: Decoder) throws {
        var arrayContainer = try decoder.unkeyedContainer()

        if let count = arrayContainer.count, count == 2 {
            let latitude = try arrayContainer.decode(CLLocationDegrees.self)
            let longitude = try arrayContainer.decode(CLLocationDegrees.self)

            self.init(latitude: latitude, longitude: longitude)
        } else {
            throw DecodingError.dataCorruptedError(in: arrayContainer, debugDescription: "Wrong number of elements in container for decoding CLLocationCoordinate2D. Array must contain two elements")
        }
    }
}
