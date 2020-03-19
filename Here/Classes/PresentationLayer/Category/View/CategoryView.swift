//
//  CategoryView.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit

final class CategoryView: UIView {

    private var didSetupConstraints: Bool = false

    lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    lazy var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

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

    // MARK: - Private
    private func setup() {
        setupTableView()
        setupLoadingIndicatorView()

        setNeedsUpdateConstraints()
    }

    private func setupTableView() {
        tableView.register(CategoryCell.self)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 51
        tableView.allowsMultipleSelection = true

        addSubview(tableView)
    }

    private func setupLoadingIndicatorView() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true

        addSubview(loadingIndicator)
    }

    private func setupConstraints() {
        tableView.ext.anchorAllEdgesToSuperview()

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            loadingIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }
}
