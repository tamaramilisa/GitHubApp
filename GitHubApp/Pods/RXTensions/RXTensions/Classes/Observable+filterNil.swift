//
//  Observable+filterNil.swift
//  RXTensions
//
//  Created by Dino on 27/09/2018.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    func filterNotNil<T>() -> Observable<T> where Self.E == T? {
        return flatMapLatest { thing -> Observable<T> in
            return thing.map(Observable.just) ?? .empty()
        }
    }
}

public extension SharedSequenceConvertibleType {
    func filterNotNil<T>() -> SharedSequence<SharingStrategy, T> where Self.E == T? {
        return flatMapLatest { thing -> SharedSequence<SharingStrategy, T> in
            return thing.map(SharedSequence.just) ?? .empty()
        }
    }
}

