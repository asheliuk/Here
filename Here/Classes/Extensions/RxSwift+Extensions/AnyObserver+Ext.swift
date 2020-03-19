//
//  AnyObserver+Ext.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

extension AnyObserver where Element == Void {

    func onNext() {
        self.onNext(())
    }
}
