//
//  PlacesTableViewHeaderView+Rx.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: PlacesTableViewHeaderView {

    var locationAddress: Binder<String?> {
        return Binder(base) { view, address in
            view.locationLabel.text = address
        }
    }

    var isLoading: Binder<Bool> {
        return Binder(base) { view, isLoading in
            view.locationCaptionLabel.isHidden = isLoading
            view.locationLabel.isHidden = isLoading

            if isLoading {
                view.loadingIndicator.startAnimating()
            } else {
                view.loadingIndicator.stopAnimating()
            }
        }
    }
}
