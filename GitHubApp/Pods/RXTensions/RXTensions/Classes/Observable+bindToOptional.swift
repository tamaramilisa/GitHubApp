//
//  Observable+bindToOptional.swift
//  Alamofire
//
//  Created by Dino on 27/09/2018.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    func bind<Observer>(to observable: Observer?) -> Disposable where Observer: ObserverType, Self.E == Observer.E {
        if let observable = observable {
            return bind(to: observable)
        } else {
            return Disposables.create()
        }
    }
}
