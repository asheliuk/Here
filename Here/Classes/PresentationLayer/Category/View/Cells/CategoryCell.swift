//
//  CategoryCell.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import HereDomain

final class CategoryCell: UITableViewCell, ReusableView {

    private var didSetupConstraints: Bool = false

    private lazy var categoryNameLabel: UILabel = UILabel()
    private lazy var categoryIconImageView: UIImageView = UIImageView()

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

        categoryNameLabel.text = nil
        categoryIconImageView.sd_cancelCurrentImageLoad()
        categoryIconImageView.image = nil
    }

    // MARK: - Public
    func bind(_ category: HereDomain.Category) {
        categoryNameLabel.text = category.title
        categoryIconImageView.sd_setImage(with: category.iconUrl, placeholderImage: nil)
    }

    // MARK: - Private
    private func setup() {
        setupCategoryNameView()
        setupCategoryIconView()

        setNeedsUpdateConstraints()
    }

    private func setupCategoryNameView() {
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(categoryNameLabel)
    }

    private func setupCategoryIconView() {
        categoryIconImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryIconImageView.contentMode = .scaleAspectFit

        contentView.addSubview(categoryIconImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            categoryIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            categoryIconImageView.widthAnchor.constraint(equalToConstant: 30),
            categoryIconImageView.heightAnchor.constraint(equalToConstant: 30),

            categoryNameLabel.leadingAnchor.constraint(equalTo: categoryIconImageView.trailingAnchor, constant: 15),
            categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            categoryNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            categoryNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            categoryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
