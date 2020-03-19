//
//  PlaceLocalDataSource.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

public class PlaceLocalDataSourceImpl: PlaceLocalDataSource {

    private var categories: [Category] = []

    // MARK: - Init
    public init() {
    }

    // MARK: - PlaceLocalDataSource
    public func hasCategories() -> Bool {
        return !categories.isEmpty
    }

    public func getCategories() -> Single<[Category]> {
        return Single.just(categories)
    }

    public func putCategories(_ categories: [Category]) {
        self.categories = categories
    }
}
