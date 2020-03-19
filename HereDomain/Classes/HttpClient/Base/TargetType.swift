//
//  TargetType.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import Alamofire

public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias URLEncoding = Alamofire.URLEncoding

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum Route {
    case get(String)
    case post(String)
    case put(String)
    case delete(String)
    case options(String)
    case head(String)
    case patch(String)
    case trace(String)
    case connect(String)

    public var path: String {
        switch self {
        case let .get(path):        return path
        case let .post(path):       return path
        case let .put(path):        return path
        case let .delete(path):     return path
        case let .options(path):    return path
        case let .head(path):       return path
        case let .patch(path):      return path
        case let .trace(path):      return path
        case let .connect(path):    return path
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .get:      return .get
        case .post:     return .post
        case .put:      return .put
        case .delete:   return .delete
        case .options:  return .options
        case .head:     return .head
        case .patch:    return .patch
        case .trace:    return .trace
        case .connect:  return .connect
        }
    }
}

public protocol Parameters {
    var asDictionary: [String: Any] { get }
}

public enum Task {
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}

public protocol PluginType {
    func prepare(_ request: URLRequest, target: TargetType) throws -> URLRequest
}

public protocol TargetType {

    var baseUrl: URL { get }
    var route: Route { get }
    var headers: [String: String]? { get }
    var task: Task { get }
}

