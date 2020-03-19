//
//  MapViewModelImpl.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

class MapViewModelImpl: MapViewModel {

    private let placesViewModel: PlacesViewModel

    private let didTriggerShowCategory: PublishSubject<Void> = PublishSubject()

    let input: MapViewModelInput
    let output: MapViewModelOutput

    // MARK: - Init
    init(placesViewModel: PlacesViewModel) {
        self.placesViewModel = placesViewModel

        input = MapViewModelInput(didTriggerShowCategory: didTriggerShowCategory.asObserver())
        output = MapViewModelOutput(
            places: placesViewModel.output.places.map { $0.map { $0.pin }},
            currentLocation: placesViewModel.output.currentLocation.map { $0.pin },
            didTriggerShowCategory: didTriggerShowCategory.asObservable(),
            didSelectPlace: placesViewModel.output.didSelectPlace
        )

        setupBindings()
    }

    // MARK: - Private
    private func setupBindings() {
        
    }
}
