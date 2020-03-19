//
//  PlaceService.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

public protocol PlaceService {

    func getCategoriesList() -> Single<[Category]>

    func getNearbyPlaces(params: GetNearbyPlacesParams, nextPage: Page<Place>?) -> Single<Page<Place>>
}


public struct GetNearbyPlacesParams: Parameters {
    let latitude: Double
    let longitude: Double
    let categories: [Id<Category>]

    // MARK: - Init
    public init(latitude: Double, longitude: Double, categories: [Id<Category>]) {
        self.latitude = latitude
        self.longitude = longitude
        self.categories = categories
    }

    // MARK: - Parameters
    public var asDictionary: [String : Any] {
        return [
            "at": "\(latitude),\(longitude)",
            "cat": "\(categories.map { $0.rawValue }.joined(separator: ","))"
        ]
    }
}
