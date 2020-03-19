//
//  MapViewModel.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift
import HereDomain

protocol MapViewModel {

    var input: MapViewModelInput { get }
    var output: MapViewModelOutput { get }
}

struct MapViewModelInput {
    let didTriggerShowCategory: AnyObserver<Void>
}

struct MapViewModelOutput {
    let places: Observable<[PlacePin]>
    let currentLocation: Observable<CurrentLocationPin>
    let didTriggerShowCategory: Observable<Void>
    let didSelectPlace: Observable<Place>
}
