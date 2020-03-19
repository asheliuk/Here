//
//  MapViewController.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import MapKit
import HereDomain

final class MapViewController: UIViewController {

    private let viewModel: MapViewModel
    private let bag: DisposeBag = DisposeBag()

    private lazy var internalView: MapView = MapView()

    // MARK: - Init
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = internalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setupBindings()
    }

    // MARK: - Private
    private func setupBindings() {
        Observable.combineLatest(viewModel.output.currentLocation, viewModel.output.places)
            .map { (currentLocationPin: CurrentLocationPin, placesPins: [PlacePin]) -> [MKAnnotation] in
                var annotations: [MKAnnotation] = placesPins
                annotations.append(currentLocationPin)

                return annotations
            }
            .bind(onNext: { [unowned self] (annotations: [MKAnnotation]) in
                self.internalView.mapView.removeAnnotations(self.internalView.mapView.annotations)

                self.internalView.mapView.addAnnotations(annotations)
                self.internalView.mapView.showAnnotations(annotations, animated: true)
            })
            .disposed(by: bag)

        viewModel.output.didSelectPlace
            .bind { [unowned self] (place: Place) in
                for case let annotation as PlacePin in self.internalView.mapView.annotations {
                    if annotation.place == place {
                        self.internalView.mapView.selectAnnotation(annotation, animated: true)
                        break
                    }
                }
            }
            .disposed(by: bag)
    }

    private func setupNavigationItem() {
        let showCategoriesBarButtonItem = UIBarButtonItem(title: "Categories", style: .plain, target: nil, action: nil)
        showCategoriesBarButtonItem.rx
            .tap
            .bind(to: viewModel.input.didTriggerShowCategory)
            .disposed(by: bag)

        navigationItem.title = "Here"
        navigationItem.rightBarButtonItem = showCategoriesBarButtonItem
    }
}
