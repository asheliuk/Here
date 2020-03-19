//
//  PlaceDataSource.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

public protocol PlaceCloudDataSource {

    func getCategories() -> Single<[Category]>

    func getNearbyPlaces(params: GetNearbyPlacesParams) -> Single<Page<Place>>
}

public protocol PlaceLocalDataSource {

    func hasCategories() -> Bool

    func getCategories() -> Single<[Category]>

    func putCategories(_ categories: [Category])
}
