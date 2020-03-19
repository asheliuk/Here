//
//  UIAlertController+Ext.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit.UIAlertController
import RxSwift

extension UIViewController: ExtensionCompatible {}

extension Extension where Base == UIAlertController {

    static func alert(from error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        return alertController
    }
}
