//
//  PlacesTarget.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

enum PlacesTarget {
    case getCategoriesList
    case getNearbyPlaces(_ params: GetNearbyPlacesParams)
}

extension PlacesTarget: TargetType {

    // MARK: - TargetType
    var baseUrl: URL { URL(string: "https://places.ls.hereapi.com")! }

    var route: Route {
        switch self {
        case .getCategoriesList: return .get("/places/v1/categories/places")
        case .getNearbyPlaces: return .get("/places/v1/discover/explore")
        }
    }

    var task: Task {
        switch self {
        case .getCategoriesList: return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getNearbyPlaces(let params): return .requestParameters(parameters: params.asDictionary, encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? { nil }
}
