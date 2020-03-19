//
//  HttplClient+Rx.swift
//  HereDomain
//
//  Created by Artem Shelyuk on 16.03.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RxSwift

extension HttpClient {

    var rx: Reactive<HttpClient> {
        return Reactive(self)
    }
}

extension Reactive where Base == HttpClient {

    func request(_ target: TargetType) -> Single<Response> {
        return Single.create { (single: @escaping (SingleEvent<Response>) -> Void) -> Disposable in
            let cancellable = self.base.request(target, completion: { (result: Result<Response, Error>) in
                switch result {
                case .success(let response):
                    single(.success(response))

                case .failure(let error):
                    single(.error(error))
                }
            })

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}
