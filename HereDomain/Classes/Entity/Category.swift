//
//  Category.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public struct Category: Codable, Hashable {

    public let id: Id<Category>
    public let title: String
    public let type: String
    public let iconUrl: URL

    // MARK: - Equatable
    public static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id, title, type, iconUrl = "icon"
    }
}
