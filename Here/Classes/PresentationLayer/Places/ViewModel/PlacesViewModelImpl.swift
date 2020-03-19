//
//  PlacesViewModelImpl.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift
import HereDomain
import CoreLocation
import RxCocoa
import RxCoreLocation

class PlacesViewModelImpl: PlacesViewModel {

    private let locationManager: CLLocationManager
    private let geocodeService: GeocodeService
    private let placeService: PlaceService

    private let places: BehaviorRelay<[Place]> = BehaviorRelay(value: [])
    private let viewDidLoad: PublishSubject<Void> = PublishSubject()
    private let error: PublishSubject<Error> = PublishSubject()
    private let categories: BehaviorSubject<[HereDomain.Category]> = BehaviorSubject(value: [])
    private let didSelectPlace: PublishSubject<Place> = PublishSubject()
    private let fetchingCurrentAddress: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let currentLocation: BehaviorRelay<CurrentLocation> = BehaviorRelay(value: .empty)
    private let bag: DisposeBag = DisposeBag()

    let input: PlacesViewModelInput
    let output: PlacesViewModelOutput

    // MARK: - Init
    init(locationManager: CLLocationManager, geocodeService: GeocodeService, placeService: PlaceService) {
        self.locationManager = locationManager
        self.geocodeService = geocodeService
        self.placeService = placeService
        
        input = PlacesViewModelInput(
            viewDidLoad: viewDidLoad.asObserver(),
            didSelectPlace: didSelectPlace.asObserver(),
            categories: categories.asObserver()
        )
        output = PlacesViewModelOutput(
            places: places.asObservable(),
            fetchingCurrentAddress: fetchingCurrentAddress.asObservable(),
            currentLocation: currentLocation.asObservable(),
            didSelectPlace: didSelectPlace.asObservable(),
            error: error.asObservable()
        )

        setupBindings()
    }

    // MARK: - Private
    private func setupBindings() {
        viewDidLoad.bind { [unowned self] in
            self.locationManager.requestWhenInUseAuthorization()
            self.fetchingCurrentAddress.accept(true)
            self.locationManager.startUpdatingLocation()
        }.disposed(by: bag)

        locationManager.rx.didError.map { $0.error }.bind(to: error).disposed(by: bag)

        locationManager.rx.didUpdateLocations.subscribe(onNext: { [unowned self] (manager: CLLocationManager, locations: [CLLocation]) in
            if let location = manager.location {
                self.updateCurrentLocation(coordinate: location.coordinate)
                self.getAddress(for: location.coordinate)
                self.loadNearbyPlaces(for: location.coordinate)
            }
        }, onError: { [unowned self] (error: Error) in
            self.error.onNext(error)
            self.fetchingCurrentAddress.accept(false)
            self.currentLocation.accept(.empty)
        }).disposed(by: bag)

        categories.bind { [unowned self] _ in
            if let location = self.locationManager.location {
                self.loadNearbyPlaces(for: location.coordinate)
            }
        }.disposed(by: bag)
    }

    private func getAddress(for coordinate: CLLocationCoordinate2D) {
        let params = GetAddressParams(latitude: coordinate.latitude, longitude: coordinate.longitude, radius: 250, maxResultsCount: 1)

        geocodeService.getAddress(with: params)
            .subscribe(onSuccess: { [unowned self] (response: GeocodeResponse) in
                if let address = response.addresses.first {
                    self.updateCurrentLocation(address: address.title)
                } else {
                    self.updateCurrentLocation(address: "Can not retieve current address")
                }
                self.fetchingCurrentAddress.accept(false)
            }, onError: { [unowned self] (error: Error) in
                self.error.onNext(error)
                self.currentLocation.accept(.empty)
                self.fetchingCurrentAddress.accept(false)
            }).disposed(by: bag)
    }

    private func loadNearbyPlaces(for coordinate: CLLocationCoordinate2D) {
        let categories: [HereDomain.Category]
        do {
            categories = try self.categories.value()
        } catch {
            categories = []
        }

        let params = GetNearbyPlacesParams(latitude: coordinate.latitude,
                                           longitude: coordinate.longitude,
                                           categories: categories.map { $0.id })

        placeService.getNearbyPlaces(params: params, nextPage: nil)
            .subscribe(onSuccess: { [unowned self] (page: Page<Place>) in
                self.places.accept(page.items)
            }, onError: { [unowned self] (error: Error) in
                self.error.onNext(error)
            }).disposed(by: bag)
    }

    private func updateCurrentLocation(coordinate: CLLocationCoordinate2D) {
        var mutableCurrentLocation = self.currentLocation.value
        mutableCurrentLocation.coordinate = coordinate

        self.currentLocation.accept(mutableCurrentLocation)
    }

    private func updateCurrentLocation(address: String) {
        var mutableCurrentLocation = self.currentLocation.value
        mutableCurrentLocation.address = address

        self.currentLocation.accept(mutableCurrentLocation)
    }
}
