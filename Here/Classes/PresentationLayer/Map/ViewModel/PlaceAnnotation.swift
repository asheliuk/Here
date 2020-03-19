//
//  Place+MKAnnotationView.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import MapKit
import HereDomain

class PlacePin: NSObject, MKAnnotation {
    let place: Place

    // MARK: - Init
    init(place: Place) {
        self.place = place
    }

    // MARK: - MKAnnotation
    var coordinate: CLLocationCoordinate2D { place.position }
    var title: String? { place.title }
    var subtitle: String? { place.vicinity }
}

extension Place {

    var pin: PlacePin { PlacePin(place: self) }
}
