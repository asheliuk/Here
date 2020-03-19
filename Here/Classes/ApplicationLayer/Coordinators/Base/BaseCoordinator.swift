//
//  BaseCoordinator.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator<ResultType> {

    private let id: String = UUID().uuidString
    private var childCoordiantors: [String: Any] = [:]

    let bag: DisposeBag = DisposeBag()

    func start() -> Single<ResultType> {
        fatalError("Should be implemented")
    }

    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Single<T> {
        save(coordinator)

        return coordinator.start()
            .do(onSuccess: { [weak self] result in
                self?.remove(coordinator)
            })
    }

    // MARK: - Private
    private func save<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordiantors[coordinator.id] = coordinator
    }

    private func remove<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordiantors[coordinator.id] = nil
    }
}
