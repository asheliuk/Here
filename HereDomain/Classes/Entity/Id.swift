//
//  Id.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public struct Id<EntityType>: Hashable {
    public typealias RawValue = String

    public let rawValue: RawValue

    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }

    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    // MARK: - Equatable
    public static func == (lhs: Id, rhs: Id) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Id: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        rawValue = try container.decode(RawValue.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
