//
//  CategoriesCoordinator.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import HereDomain

enum CategoriesCoordinatorResult {
    case categories(_ categories: [HereDomain.Category])
    case cancel
}

final class CategoriesCoordinator: BaseCoordinator<CategoriesCoordinatorResult> {

    private let rootViewController: UIViewController

    // MARK: - Init
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Single<CategoriesCoordinatorResult> {
        let (categoryViewController, categoryViewModel) = CategoryAssembly.module()
        let navigationController = UINavigationController(rootViewController: categoryViewController)

        let cancel = categoryViewModel.output.didTriggerCancel.map { CategoriesCoordinatorResult.cancel }
        let done = categoryViewModel.output.didTriggerDone.withLatestFrom(categoryViewModel.output.selectedCategories).map { CategoriesCoordinatorResult.categories($0) }

        rootViewController.present(navigationController, animated: true, completion: nil)

        return Observable.merge(cancel, done).take(1).asSingle().do(onSuccess: { [weak self] _ in
            self?.rootViewController.dismiss(animated: true, completion: nil)
        })
    }
}
