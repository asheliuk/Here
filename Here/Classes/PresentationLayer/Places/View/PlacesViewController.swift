//
//  PlacesViewController.swift
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

final class PlacesViewController: UIViewController {

    typealias Section = SectionModel<Int, Place>

    private let viewModel: PlacesViewModel
    private let bag: DisposeBag = DisposeBag()

    lazy var internalView: PlacesView = PlacesView()
    lazy var dataSource: RxTableViewSectionedReloadDataSource = setupDataSource()

    // MARK: - Init
    init(viewModel: PlacesViewModel) {
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

        setupBindings()
    }

    // MARK: - Private
    private func setupBindings() {
        viewModel.output.currentLocation
            .map { $0.address }
            .bind(to: internalView.tableHeaderView.rx.locationAddress)
            .disposed(by: bag)

        viewModel.output.fetchingCurrentAddress
            .bind(to: internalView.tableHeaderView.rx.isLoading)
            .disposed(by: bag)

        viewModel.output.places
            .map({ (places: [Place]) -> [Section] in
                return places.isEmpty ? [] : [Section(model: 0, items: places)]
            })
            .bind(to: internalView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        viewModel.output.error
            .bind { [unowned self] (error: Error) in
                self.present(UIAlertController.ext.alert(from: error), animated: true, completion: nil)
            }.disposed(by: bag)

        internalView.tableView.rx
            .modelSelected(Place.self)
            .bind(to: viewModel.input.didSelectPlace)
            .disposed(by: bag)

        viewModel.input.viewDidLoad.onNext()
    }

    private func setupDataSource() -> RxTableViewSectionedReloadDataSource<Section> {
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: { (_, tableView, indexPath, place) -> UITableViewCell in
            let cell: PlaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.bind(place)

            return cell
        })
        dataSource.titleForHeaderInSection = { (dataSource, section) in
            if dataSource.sectionModels.isEmpty {
                return nil
            } else {
                return "Nearby places:"
            }
        }

        return dataSource
    }
}
