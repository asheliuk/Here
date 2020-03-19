//
//  HttpClient.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

public protocol HttpClient {

    func request(_ target: TargetType, completion: @escaping (Swift.Result<Response, Error>) -> Void) -> Cancellable

    func addPlugin(_ plugin: PluginType)
}
