//
//  CategoryViewModelImpl.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import HereDomain

class CategoryViewModelImpl: CategoryViewModel {

    private let categoryService: PlaceService

    private let categories: BehaviorRelay<[HereDomain.Category]> = BehaviorRelay(value: [])
    private let selectedCategories: BehaviorRelay<[HereDomain.Category]> = BehaviorRelay(value: [])
    private let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let viewDidLoad: PublishSubject<Void> = PublishSubject()
    private let didTriggerCancel: PublishSubject<Void> = PublishSubject()
    private let didTriggerDone: PublishSubject<Void> = PublishSubject()
    private let didSelectCategory: PublishSubject<HereDomain.Category> = PublishSubject()
    private let error: PublishSubject<Error> = PublishSubject()
    private let bag: DisposeBag = DisposeBag()

    @CodableUserDefault(key: "selectedCategoriesIdentifiers")
    private var defaultSelectedCategories: [HereDomain.Category]?

    let input: CategoryViewModelInput
    let output: CategoryViewModelOutput

    // MARK: - Init
    init(categoryService: PlaceService) {
        self.categoryService = categoryService

        input = CategoryViewModelInput(
            viewDidLoad: viewDidLoad.asObserver(),
            didTriggerCancel: didTriggerCancel.asObserver(),
            didTriggerDone: didTriggerDone.asObserver(),
            didSelectCategory: didSelectCategory.asObserver()
        )
        output = CategoryViewModelOutput(
            categories: categories.asObservable(),
            selectedCategories: selectedCategories.asObservable(),
            isLoading: isLoading.asObservable(),
            didTriggerCancel: didTriggerCancel.asObservable(),
            didTriggerDone: didTriggerDone.asObservable(),
            error: error.asObservable()
        )

        selectedCategories.accept(defaultSelectedCategories ?? [])
        setupBindings()
    }

    // MARK: - CategoryViewModel
    func isCategorySelected(_ category: HereDomain.Category) -> Bool {
        return selectedCategories.value.contains(category)
    }

    // MARK: - Private
    private func setupBindings() {
        viewDidLoad.bind { [unowned self] in
            self.loadCategories()
        }.disposed(by: bag)

        didSelectCategory.bind { [unowned self] (category: HereDomain.Category) in            
            var mutableSelectedCategories = self.selectedCategories.value
            if let index = mutableSelectedCategories.firstIndex(of: category) {
                mutableSelectedCategories.remove(at: index)
            } else {
                mutableSelectedCategories.append(category)
            }

            self.selectedCategories.accept(mutableSelectedCategories)
        }.disposed(by: bag)

        didTriggerDone.bind { [unowned self] in
            self.defaultSelectedCategories = self.selectedCategories.value
        }.disposed(by: bag)
    }

    private func loadCategories() {
        isLoading.accept(true)

        categoryService.getCategoriesList().subscribe(onSuccess: { (categories: [HereDomain.Category]) in
            self.isLoading.accept(false)
            self.categories.accept(categories)
        }, onError: { (error: Error) in
            self.isLoading.accept(false)
            self.error.onError(error)
        }).disposed(by: bag)
    }
}
