//
//  MapView.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import MapKit
import UIKit

final class MapView: UIView, MKMapViewDelegate {

    private var didSetupConstraints: Bool = false

    lazy var mapView: MKMapView = MKMapView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame); setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder); setup()
    }

    // MARK: - Overrides
    override func updateConstraints() {
        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }

        super.updateConstraints()
    }

    // MARK: - Private
    private func setup() {
        setupMapView()

        setNeedsUpdateConstraints()
    }

    private func setupMapView() {
        mapView.delegate = self
        addSubview(mapView)
    }

    private func setupConstraints() {
        mapView.ext.anchorAllEdgesToSuperview()
    }

    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "currentLocationPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = annotation is CurrentLocationPin ? #imageLiteral(resourceName: "CurrentPin") : #imageLiteral(resourceName: "Pin")

        return annotationView
    }

}

