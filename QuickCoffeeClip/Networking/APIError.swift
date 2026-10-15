//
//  APIError.swift
//  QuickCoffeeClip
//

import Foundation

struct APIErrorResponse: Decodable {
    let message: String?
    let error: String?
    let code: String?
}

enum APIError: LocalizedError {
    case invalidURL(String)
    case invalidResponse
    case emptyResponse
    case informational(statusCode: Int, data: Data)
    case redirection(statusCode: Int, location: String?, data: Data)
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case notFound(message: String?)
    case conflict(message: String?)
    case validationFailed(message: String?)
    case rateLimited(message: String?)
    case clientError(statusCode: Int, message: String?, data: Data)
    case serverError(statusCode: Int, message: String?, data: Data)
    case decodingFailed(Error)
    case transportFailed(URLError)
    case requestFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let value):
            return "Invalid API URL: \(value)"
        case .invalidResponse:
            return "The server returned an invalid response."
        case .emptyResponse:
            return "The server returned an empty response."
        case .informational(let statusCode, _):
            return "Unexpected informational status code: \(statusCode)."
        case .redirection(let statusCode, let location, _):
            return "Unexpected redirection status code: \(statusCode). Location: \(location ?? "none")."
        case .unauthorized(let message):
            return message ?? "Unauthorized request."
        case .forbidden(let message):
            return message ?? "Forbidden request."
        case .notFound(let message):
            return message ?? "Requested resource was not found."
        case .conflict(let message):
            return message ?? "Request conflict."
        case .validationFailed(let message):
            return message ?? "Validation failed."
        case .rateLimited(let message):
            return message ?? "Too many requests. Please retry later."
        case .clientError(let statusCode, let message, _):
            return message ?? "Client error with status code \(statusCode)."
        case .serverError(let statusCode, let message, _):
            return message ?? "Server error with status code \(statusCode)."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .transportFailed(let error):
            return "Network transport error: \(error.localizedDescription)"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        }
    }
}

extension APIErrorResponse {
    var readableMessage: String? {
        message ?? error ?? code
    }
}
