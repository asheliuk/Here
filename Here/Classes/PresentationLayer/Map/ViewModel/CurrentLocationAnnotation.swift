//
//  CurrentLocationAnnotation.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import MapKit

class CurrentLocationPin: NSObject, MKAnnotation {
    let currentLocation: CurrentLocation

    // MARK: - Init
    init(currentLocation: CurrentLocation) {
        self.currentLocation = currentLocation
    }

    // MARK: - MKAnnotation
    var coordinate: CLLocationCoordinate2D { currentLocation.coordinate }

    var title: String? { "Current location" }
    var subtitle: String? { currentLocation.address }
}

extension CurrentLocation {

    var pin: CurrentLocationPin { CurrentLocationPin(currentLocation: self) }
}

