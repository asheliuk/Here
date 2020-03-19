//
//  PlaceServiceImpl.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

public final class PlaceServiceImpl: PlaceService {

    private let cloudDataSource: PlaceCloudDataSource
    private let localDataSource: PlaceLocalDataSource

    // MARK: - Init
    public init(cloudDataSource: PlaceCloudDataSource, localDataSource: PlaceLocalDataSource) {
        self.cloudDataSource = cloudDataSource
        self.localDataSource = localDataSource
    }

    // MARK: - PlaceService
    public func getCategoriesList() -> Single<[Category]> {
        if localDataSource.hasCategories() {
            return localDataSource.getCategories()
        } else {
            return cloudDataSource.getCategories()
        }
    }

    public func getNearbyPlaces(params: GetNearbyPlacesParams, nextPage: Page<Place>?) -> Single<Page<Place>> {
        if let _ = nextPage {
            return Single.just(Page<Place>(next: nil, prev: nil, items: []))
        } else {
            return cloudDataSource.getNearbyPlaces(params: params)
        }
    }
}
