//
//  UserDefault.swift
//  Here
//
//  Created by Artem Shelyuk on 17.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

@propertyWrapper struct CodableUserDefault<T: Codable> {

    let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            do {
                return try UserDefaults.standard.get(objectType: T.self, forKey: key)
            } catch {
                debugPrint("Error occured when tried to decode \(T.self). Error: \(error)")
                return nil
            }
        }
        set {
            try? UserDefaults.standard.set(object: newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

extension UserDefaults {

    public func set<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try JSONEncoder().encode(object)

        set(jsonData, forKey: forKey)
    }

    public func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else { return nil }

        return try JSONDecoder().decode(objectType, from: result)
    }
}
