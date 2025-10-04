import Foundation

public enum AppError: Error, LocalizedError {
    case network(underlying: Error)
    case decoding(underlying: Error)
    case persistence(underlying: Error)
    case notFound
    case invalidState(description: String)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .network(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        case .decoding(let underlying):
            return "Failed to decode server response: \(underlying.localizedDescription)"
        case .persistence(let underlying):
            return "Persistence failure: \(underlying.localizedDescription)"
        case .notFound:
            return "Requested resource was not found."
        case .invalidState(let description):
            return description
        case .unknown:
            return "Unexpected error occurred."
        }
    }
}
