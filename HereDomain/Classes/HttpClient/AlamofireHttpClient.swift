//
//  AlamofireHttpClient.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import Alamofire

public final class AlamofireHttpClient: HttpClient {

    private let sessionManager: SessionManager
    private var plugins: [PluginType] = []

    // MARK: - Init
    public init(sessionConfiguration: URLSessionConfiguration) {
        sessionManager = SessionManager(configuration: sessionConfiguration,
                                        delegate: SessionDelegate(),
                                        serverTrustPolicyManager: ServerTrustPolicyManager(policies: [:]))
    }

    // MARK: - HttpClient
    public func request(_ target: TargetType, completion: @escaping (Swift.Result<Response, Error>) -> Void) -> Cancellable {
        let cancellable: CancellableWrapper = CancellableWrapper()
        cancellable.innerCancellable = performRequest(target: target, completion: completion)

        return cancellable
    }

    public func addPlugin(_ plugin: PluginType) {
        plugins.append(plugin)
    }

    // MARK: - Private
    private func performRequest(target: TargetType, completion: @escaping (Swift.Result<Response, Error>) -> Void) -> Cancellable {
        var urlRequest: URLRequest

        do {
            urlRequest = try createUrlRequest(from: target)
            urlRequest = try plugins.reduce(urlRequest) { try $1.prepare($0, target: target) }
        } catch {
            completion(.failure(error))
            return CancellableWrapper()
        }

        switch target.task {
        case .requestParameters:
            return sendRequest(target: target, urlRequest: urlRequest, completion: completion)
        }
    }

    private func sendRequest(target: TargetType, urlRequest: URLRequest, completion: @escaping (Swift.Result<Response, Error>) -> Void) -> Cancellable {
        let request = sessionManager.request(urlRequest)

        return sendAlamofireRequest(target: target, request: request, completion: completion)
    }

    private func sendAlamofireRequest(target: TargetType, request: DataRequest, completion: @escaping (Swift.Result<Response, Error>) -> Void) -> Cancellable {
        let dataRequest: DataRequest = request.validate(statusCode: 200...299)

        dataRequest.response { [weak self] (alamofireResponse: DefaultDataResponse) in
            guard let self = self else { return }
            completion(self.convertAlamofireResponseToResult(alamofireResponse))
        }

        dataRequest.resume()

        return CancellableToken(request: dataRequest)
    }

    private func createUrlRequest(from target: TargetType) throws -> URLRequest {
        let url: URL = target.baseUrl.appendingPathComponent(target.route.path)
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod           = target.route.method.rawValue
        urlRequest.allHTTPHeaderFields  = target.headers

        switch target.task {
        case let .requestParameters(params, encoding):
            return try encoding.encode(urlRequest, with: params)
        }
    }

    private func convertAlamofireResponseToResult(_ alamofireResponse: DefaultDataResponse) -> Swift.Result<Response, Error> {
        let response: HTTPURLResponse? = alamofireResponse.response
        let data: Data? = alamofireResponse.data
        let error: Error? = alamofireResponse.error

        switch (response, data, error) {
        case let (.some(response), data, .none):
            return .success(
                Response(statusCode: response.statusCode, data: data ?? Data(), request: alamofireResponse.request, response: response)
            )

        case let (_, _, .some(error)):
            return .failure(error)

        default:
            return .failure(
                NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
            )
        }
    }
}

private final class CancellableToken: Cancellable, CustomDebugStringConvertible {
    let cancelAction: () -> Void
    let request: Request?

    public fileprivate(set) var isCancelled = false

    fileprivate var lock: DispatchSemaphore = DispatchSemaphore(value: 1)

    public func cancel() {
        _ = lock.wait(timeout: DispatchTime.distantFuture)
        defer { lock.signal() }
        guard !isCancelled else { return }
        isCancelled = true
        cancelAction()
    }

    public init(action: @escaping () -> Void) {
        self.cancelAction = action
        self.request = nil
    }

    init(request: Request) {
        self.request = request
        self.cancelAction = {
            request.cancel()
        }
    }

    public var debugDescription: String {
        guard let request = self.request else {
            return "Empty Request"
        }
        return request.debugDescription
    }
}

