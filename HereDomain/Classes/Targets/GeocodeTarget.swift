//
//  PlaceTarget.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

enum GeocodeTarget {

    case getAddress(_ params: GetAddressParams)
}

extension GeocodeTarget: TargetType {

    var baseUrl: URL { URL(string: "https://reverse.geocoder.ls.hereapi.com")! }

    var route: Route {
        switch self {
        case .getAddress: return .get("/6.2/reversegeocode.json")
        }
    }

    var task: Task {
        switch self {
        case .getAddress(let params): return .requestParameters(parameters: params.asDictionary, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? { nil }
}
