//
//  ApplicationAssembly.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import Dip
import HereDomain
import CoreLocation

let applicationAssembly = DependencyContainer(autoInjectProperties: true) { (container: DependencyContainer) in
    unowned let container = container

    // MARK: - Application
    container.register(.singleton) { UIWindow(frame: UIScreen.main.bounds) }
    container.register(.singleton, type: ApplicationCoordinator.self, factory: ApplicationCoordinator.init)

    // MARK: - Map Screen
    container.register(.shared, type: MapViewModel.self, factory: MapViewModelImpl.init)

    // MARK: - Places Screen
    container.register(.weakSingleton, type: PlacesViewModel.self, factory: PlacesViewModelImpl.init)

    // MARK: - Categories Screen
    container.register(.shared, type: CategoryViewModel.self, factory: CategoryViewModelImpl.init)

    // MARK: - Network
    container.register(.weakSingleton, tag: "authPlugin") { AuthPlugin(apiKey: "CRkKOdpbkJ_kz1QKtUKFEeVv5cwWvqHt8CRcDa_F_Ow") as PluginType }
    container.register(.singleton) { URLSessionConfiguration.default }
    container.register(.singleton, type: HttpClient.self, factory: AlamofireHttpClient.init)
        .resolvingProperties { (_, httpClient: HttpClient) in
            httpClient.addPlugin(try! container.resolve(tag: "authPlugin"))
        }

    // MARK: - Place Service
    container.register(.weakSingleton, type: PlaceCloudDataSource.self, factory: PlaceCloudDataSourceImpl.init)
    container.register(.weakSingleton, type: PlaceLocalDataSource.self, factory: PlaceLocalDataSourceImpl.init)
    container.register(.weakSingleton, type: PlaceService.self, factory: PlaceServiceImpl.init)

    // MARK: - Geocode Service
    container.register(.weakSingleton, type: GeocodeService.self, factory: GeocodeServiceImpl.init)

    // MARK: - Location
    container.register(.singleton) { CLLocationManager() }
}
