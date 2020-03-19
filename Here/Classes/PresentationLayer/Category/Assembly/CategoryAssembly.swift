//
//  CategoryAssembly.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

final class CategoryAssembly {

    static func module() -> (CategoryViewController, CategoryViewModel) {
        let viewModel: CategoryViewModel = try! applicationAssembly.resolve()
        return (CategoryViewController(viewModel: viewModel), viewModel)
    }
}
