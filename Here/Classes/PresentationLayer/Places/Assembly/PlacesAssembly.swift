//
//  PlacesAssembly.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

final class PlacesAssembly {

    static func module() -> (PlacesViewController, PlacesViewModel) {
        let viewModel: PlacesViewModel = try! applicationAssembly.resolve()
        return (PlacesViewController(viewModel: viewModel), viewModel)
    }
}
