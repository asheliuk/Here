//
//  GeocodeService.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

public protocol GeocodeService {

    func getAddress(with params: GetAddressParams) -> Single<GeocodeResponse>
}

public struct GetAddressParams: Parameters {
    public let latitude: Double
    public let longitude: Double
    public let radius: Double
    public let maxResultsCount: Int

    // MARK: - Init
    public init(latitude: Double, longitude: Double, radius: Double, maxResultsCount: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.maxResultsCount = maxResultsCount
    }

    // MARK: - Parameters
    public var asDictionary: [String : Any] {[
        "prox": "\(latitude),\(longitude),\(radius)",
        "maxresults": maxResultsCount,
        "mode": "retrieveAddresses"
    ]}
}
