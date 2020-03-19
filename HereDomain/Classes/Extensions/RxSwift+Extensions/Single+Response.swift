//
//  Single+Response.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

internal extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func decode<T: Decodable>(_ object: T.Type) -> Single<T> {
        return map { try $0.decode(T.self) }
    }
}
