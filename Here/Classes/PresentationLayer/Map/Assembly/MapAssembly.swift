//
//  MapAssembly.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

final class MapAssembly {

    static func module() -> (MapViewController, MapViewModel) {
        let viewModel: MapViewModel = try! applicationAssembly.resolve()
        
        return (MapViewController(viewModel: viewModel), viewModel)
    }
}
