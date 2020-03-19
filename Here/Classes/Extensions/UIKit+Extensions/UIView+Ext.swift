//
//  UIView+Ext.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit

extension UIView: ExtensionCompatible {}

extension Extension where Base: UIView {

    func anchorAllEdgesToSuperview(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard base.superview != nil else { return }
        base.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            base.topAnchor.constraint(equalTo: base.superview!.topAnchor, constant: insets.top),
            base.leadingAnchor.constraint(equalTo: base.superview!.leadingAnchor, constant: insets.left),
            base.bottomAnchor.constraint(equalTo: base.superview!.bottomAnchor, constant: insets.bottom),
            base.trailingAnchor.constraint(equalTo: base.superview!.trailingAnchor, constant: insets.right)
        ])
    }
}
