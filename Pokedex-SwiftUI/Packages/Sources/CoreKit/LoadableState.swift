import Foundation

public enum LoadableState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(AppError)

    public var value: Value? {
        if case .loaded(let value) = self { return value }
        return nil
    }

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
