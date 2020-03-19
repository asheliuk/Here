//
//  ApplicationCoordinator.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift
import OverlayContainer
import HereDomain
import CoreLocation

final class ApplicationCoordinator: BaseCoordinator<Void>, OverlayContainerViewControllerDelegate {

    private let window: UIWindow

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Override
    override func start() -> Single<Void> {
        runMainFlow()

        return Single.never()
    }

    // MARK: - Private
    private func runMainFlow() {
        let (mapViewController, mapViewModel) = MapAssembly.module()
        let (placesViewController, placesViewModel) = PlacesAssembly.module()

        mapViewModel.output.didTriggerShowCategory
            .flatMap { [unowned self] _ -> Observable<[HereDomain.Category]> in
                return self.runCategoriesFlow(on: mapViewController).asObservable()
            }
            .bind(to: placesViewModel.input.categories)
            .disposed(by: bag)

        let mainViewController = UINavigationController(rootViewController: mapViewController)

        let containerViewController = OverlayContainerViewController(style: .rigid)
        containerViewController.delegate = self
        containerViewController.viewControllers = [mainViewController, placesViewController]

        window.rootViewController = containerViewController
        window.makeKeyAndVisible()
    }

    private func runCategoriesFlow(on rootViewController: UIViewController) -> Single<[HereDomain.Category]> {
        let categoriesCoordinator = CategoriesCoordinator(rootViewController: rootViewController)

        return coordinate(to: categoriesCoordinator)
            .map { (result: CategoriesCoordinatorResult) -> [HereDomain.Category] in
                switch result {
                case .cancel: return []
                case .categories(let selectedCategories): return selectedCategories
                }
        }
    }

    // MARK: - OverlayContainerViewControllerDelegate
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return OverlayNotch.allCases.count
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        switch OverlayNotch.allCases[index] {
            case .maximum:
                return availableSpace * 0.65
            case .medium:
                return availableSpace * 0.5
            case .minimum:
                return availableSpace * 0.35
        }
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, scrollViewDrivingOverlay overlayViewController: UIViewController) -> UIScrollView? {
        return (overlayViewController as! PlacesViewController).internalView.tableView
    }
}

enum OverlayNotch: Int, CaseIterable {
    case minimum, medium, maximum
}
