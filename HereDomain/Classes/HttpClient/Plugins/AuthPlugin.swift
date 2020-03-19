//
//  AuthPlugin.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public class AuthPlugin: PluginType {

    private let apiKey: String

    // MARK: - Init
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: - PluginType
    public func prepare(_ request: URLRequest, target: TargetType) throws -> URLRequest {
        var mutableRequest = request

        switch target.task {
        case .requestParameters(let params, let encoding):
            mutableRequest = try encoding.encode(mutableRequest, with: extend(params: params))
        }

        return mutableRequest
    }

    // MARK: - Private
    private func extend(params: [String: Any]) -> [String: Any] {
        var mutableParams = params
        mutableParams["apiKey"] = apiKey

        return mutableParams
    }
}
