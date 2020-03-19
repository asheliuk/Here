//
//  Extensions.swift
//  Here
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public struct Extension<Base> {
    public let base: Base

    fileprivate init(_ base: Base) {
        self.base = base
    }
}

public protocol ExtensionCompatible {
    associatedtype CompatibleType

    static var ext: Extension<CompatibleType>.Type { get }

    var ext: Extension<CompatibleType> { get }
}

extension ExtensionCompatible {

    public static var ext: Extension<Self>.Type {
        return Extension<Self>.self
    }

    public var ext: Extension<Self> {
        return Extension(self)
    }
}
