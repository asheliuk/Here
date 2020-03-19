//
//  GeocodeServiceImpl.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

public class GeocodeServiceImpl: GeocodeService {

    private let httpClient: HttpClient

    // MARK: - Init
    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }

    // MARK: - GeocodeService
    public func getAddress(with params: GetAddressParams) -> Single<GeocodeResponse> {
        return httpClient.rx
            .request(GeocodeTarget.getAddress(params))
            .decode(GeocodeResponse.self)
    }
}
