//
//  PlacesTableViewHeaderView.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit

class PlacesTableViewHeaderView: UIView {

    private var didSetupConstraints: Bool = false

    lazy var locationCaptionLabel: UILabel = UILabel()
    lazy var locationLabel: UILabel = UILabel()
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
        setupLocationCaptionView()
        setupLocationView()
        setupLoadingIndicator()

        setNeedsUpdateConstraints()
    }

    private func setupLocationCaptionView() {
        locationCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        locationCaptionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        locationCaptionLabel.text = "Your current location address:"
        locationCaptionLabel.numberOfLines = 0

        addSubview(locationCaptionLabel)
    }

    private func setupLocationView() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0

        addSubview(locationLabel)
    }

    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true

        addSubview(loadingIndicator)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            locationCaptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationCaptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            locationCaptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),

            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            locationLabel.topAnchor.constraint(equalTo: locationCaptionLabel.bottomAnchor, constant: 5),
            locationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ])
    }
}
