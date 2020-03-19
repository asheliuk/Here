//
//  PlaceCloudDataSource.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

public class PlaceCloudDataSourceImpl: PlaceCloudDataSource {

    private let httpClient: HttpClient

    // MARK: - Init
    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }

    // MARK: - PlaceCloudDataSource
    public func getCategories() -> Single<[Category]> {
        return httpClient.rx
            .request(PlacesTarget.getCategoriesList)
            .decode(ItemsResponse<Category>.self)
            .map { $0.items }
    }

    public func getNearbyPlaces(params: GetNearbyPlacesParams) -> Single<Page<Place>> {
        return httpClient.rx
            .request(PlacesTarget.getNearbyPlaces(params))
            .decode(ResultsResponse<Page<Place>>.self)
            .map { $0.results }
    }
}
