//
//  CategoryViewModel.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift
import HereDomain

protocol CategoryViewModel {

    var input: CategoryViewModelInput { get }
    var output: CategoryViewModelOutput { get }

    func isCategorySelected(_ category: HereDomain.Category) -> Bool
}

struct CategoryViewModelInput {
    let viewDidLoad: AnyObserver<Void>
    let didTriggerCancel: AnyObserver<Void>
    let didTriggerDone: AnyObserver<Void>
    let didSelectCategory: AnyObserver<HereDomain.Category>
}

struct CategoryViewModelOutput {
    let categories: Observable<[HereDomain.Category]>
    let selectedCategories: Observable<[HereDomain.Category]>
    let isLoading: Observable<Bool>
    let didTriggerCancel: Observable<Void>
    let didTriggerDone: Observable<Void>
    let error: Observable<Error>
}
