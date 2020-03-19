//
//  CategoryViewController.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import HereDomain

final class CategoryViewController: UIViewController {

    typealias Section = SectionModel<Int, HereDomain.Category>

    private let viewModel: CategoryViewModel
    private let bag: DisposeBag = DisposeBag()

    lazy var internalView: CategoryView = CategoryView()
    lazy var dataSource: RxTableViewSectionedReloadDataSource<Section> = setupDataSource()

    // MARK: - Init
    init(viewModel: CategoryViewModel) {
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
        viewModel.output.categories
            .map({ (categories: [HereDomain.Category]) -> [Section] in
                return [Section(model: 0, items: categories)]
            })
            .bind(to: internalView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        viewModel.output.isLoading
            .bind(to: internalView.loadingIndicator.rx.isAnimating)
            .disposed(by: bag)

        viewModel.output.error
            .bind { [unowned self] (error: Error) in
                self.present(UIAlertController.ext.alert(from: error), animated: true, completion: nil)
            }
            .disposed(by: bag)

        internalView.tableView.rx.modelSelected(HereDomain.Category.self)
            .bind(to: viewModel.input.didSelectCategory)
            .disposed(by: bag)

        internalView.tableView.rx.modelDeselected(HereDomain.Category.self)
            .bind(to: viewModel.input.didSelectCategory)
            .disposed(by: bag)

        internalView.tableView.rx.willDisplayCell.bind { [unowned self] (cell: UITableViewCell, indexPath: IndexPath) in
            let category = self.dataSource.sectionModels[indexPath.section].items[indexPath.item]

            if self.viewModel.isCategorySelected(category) {
                self.internalView.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }.disposed(by: bag)

        viewModel.input.viewDidLoad.onNext()
    }

    private func setupNavigationItem() {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        cancelBarButtonItem.rx.tap
            .bind(to: viewModel.input.didTriggerCancel)
            .disposed(by: bag)

        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
        doneBarButtonItem.rx.tap
            .bind(to: viewModel.input.didTriggerDone)
            .disposed(by: bag)

        navigationItem.title = "Categories"
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }

    private func setupDataSource() -> RxTableViewSectionedReloadDataSource<Section> {
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: { (_, tableView, indexPath, category) -> UITableViewCell in
            let cell: CategoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.bind(category)

            return cell
        })

        return dataSource
    }
}

extension HereDomain.Category: IdentifiableType {
    public typealias Identity = Id<HereDomain.Category>

    public var identity: Id<HereDomain.Category> { id }
}
