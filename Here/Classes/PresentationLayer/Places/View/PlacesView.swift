//
//  PlacesView.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit

final class PlacesView: UIView {

    private var didSetupConstraints: Bool = false

    lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    lazy var tableHeaderView: PlacesTableViewHeaderView = PlacesTableViewHeaderView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame); setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder); setup()
    }

    // MARK: - Override
    override func updateConstraints() {
        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }

        super.updateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = tableView.tableHeaderView
    }

    // MARK: - Private
    private func setup() {
        setupTableView()

        setNeedsUpdateConstraints()
    }

    private func setupTableView() {
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView()
        tableView.register(PlaceCell.self)

        addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.ext.anchorAllEdgesToSuperview()

        NSLayoutConstraint.activate([
            tableHeaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            tableHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
        ])
    }
}
