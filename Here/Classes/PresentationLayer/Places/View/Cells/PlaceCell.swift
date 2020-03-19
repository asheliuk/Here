//
//  PlaceCell.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import HereDomain

final class PlaceCell: UITableViewCell, ReusableView {

    private var didSetupConstraints: Bool = false

    private lazy var placeNameLabel: UILabel = UILabel()
    private lazy var placeIconImageView: UIImageView = UIImageView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier); setup()
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

    override func prepareForReuse() {
        super.prepareForReuse()

        placeNameLabel.text = nil
        placeIconImageView.sd_cancelCurrentImageLoad()
        placeIconImageView.image = nil
    }

    // MARK: - Public
    func bind(_ place: Place) {
        placeNameLabel.text = place.title
        placeIconImageView.sd_setImage(with: place.icon, placeholderImage: nil)
    }

    // MARK: - Private
    private func setup() {
        setupPlaceNameView()
        setupPlaceIconView()

        setNeedsUpdateConstraints()
    }

    private func setupPlaceNameView() {
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(placeNameLabel)
    }

    private func setupPlaceIconView() {
        placeIconImageView.translatesAutoresizingMaskIntoConstraints = false
        placeIconImageView.contentMode = .scaleAspectFit

        contentView.addSubview(placeIconImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            placeIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            placeIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            placeIconImageView.widthAnchor.constraint(equalToConstant: 30),
            placeIconImageView.heightAnchor.constraint(equalToConstant: 30),

            placeNameLabel.leadingAnchor.constraint(equalTo: placeIconImageView.trailingAnchor, constant: 15),
            placeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            placeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            placeNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            placeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
