import RxSwift
import Alamofire

public extension ObservableType {
    /// Subscribe to an observable containing an `Alamofire.Result<T>`
    func subscribe<R>(
        onSuccess: ((R) -> Void)?,
        onError: ((Error) -> Void)?)
    -> Disposable where Element == Alamofire.Result<R>
    {
        let disposable = Disposables.create()
        
        let observer = AnyObserver<Element> { event in
            switch event {
            case let .next(value):
                switch value {
                case let .success(successValue):
                    onSuccess?(successValue)
                case let .failure(error):
                    onError?(error)
                }
            case let .error(error):
                if let onError = onError {
                    onError(error)
                } else {
                    Hooks.defaultErrorHandler([], error)
                }
                disposable.dispose()
            default:
                break
            }
        }
        
        return Disposables.create(
            self.asObservable().subscribe(observer),
            disposable
        )
    }
}

public extension ObservableType {
    /// Subscribe to an observable containing a `Swift.Result<T>`
    func subscribe<R>(
        onSuccess: ((R) -> Void)?,
        onError: ((Error) -> Void)?)
        -> Disposable where Element == Swift.Result<R, Error>
    {
        let disposable = Disposables.create()
        
        let observer = AnyObserver<Element> { event in
            switch event {
            case let .next(value):
                switch value {
                case let .success(successValue):
                    onSuccess?(successValue)
                case let .failure(error):
                    onError?(error)
                }
            case let .error(error):
                if let onError = onError {
                    onError(error)
                } else {
                    Hooks.defaultErrorHandler([], error)
                }
                disposable.dispose()
            default:
                break
            }
        }
        
        return Disposables.create(
            self.asObservable().subscribe(observer),
            disposable
        )
    }
}
