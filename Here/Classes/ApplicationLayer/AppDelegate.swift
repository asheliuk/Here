//
//  AppDelegate.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit
import CoreLocation
import HereDomain
import RxSwift

//let apiKey: String = "CRkKOdpbkJ_kz1QKtUKFEeVv5cwWvqHt8CRcDa_F_Ow"
//let apiId: String = "Y9octREXv8xgOLNN88vG"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var applicationCoordinator: ApplicationCoordinator!
    private var bag: DisposeBag = DisposeBag()

    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startApplicationFlow()

        return true
    }

    // MARK: - Private
    private func startApplicationFlow() {
        applicationCoordinator = try! applicationAssembly.resolve()
        applicationCoordinator.start().subscribe().disposed(by: bag)
    }
}

