//
//  PlacesViewModel.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift
import HereDomain
import CoreLocation

protocol PlacesViewModel {

    var input: PlacesViewModelInput { get }
    var output: PlacesViewModelOutput { get }
}


struct PlacesViewModelInput {
    let viewDidLoad: AnyObserver<Void>
    let didSelectPlace: AnyObserver<Place>
    let categories: AnyObserver<[HereDomain.Category]>
}

struct PlacesViewModelOutput {
    let places: Observable<[Place]>
    let fetchingCurrentAddress: Observable<Bool>
    let currentLocation: Observable<CurrentLocation>
    let didSelectPlace: Observable<Place>
    let error: Observable<Error>
}

struct CurrentLocation {
    static var empty: CurrentLocation = CurrentLocation(coordinate: .init(), address: "")
    
    var coordinate: CLLocationCoordinate2D
    var address: String
}
