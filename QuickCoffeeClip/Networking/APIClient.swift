//
//  APIClient.swift
//  QuickCoffeeClip
//

import Foundation

final class APIClient {
    static let shared = APIClient(configuration: APIEnvironment.configuration)

    private let configuration: APIConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        configuration: APIConfiguration,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        as responseType: T.Type = T.self
    ) async throws -> T {
        let data = try await requestData(endpoint)

        if data.isEmpty, let emptyResponse = EmptyResponse() as? T {
            return emptyResponse
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            APILogger.logError(error)
            throw APIError.decodingFailed(error)
        }
    }

    func requestData(_ endpoint: APIEndpoint) async throws -> Data {
        let request = try makeURLRequest(from: endpoint)

        if configuration.logsNetworkResponses {
            APILogger.logRequest(request)
        }

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            if configuration.logsNetworkResponses {
                APILogger.logResponse(data: data, response: httpResponse)
            }

            try validate(statusCode: httpResponse.statusCode, data: data, response: httpResponse)
            return data
        } catch let error as APIError {
            APILogger.logError(error)
            throw error
        } catch let error as URLError {
            let apiError = APIError.transportFailed(error)
            APILogger.logError(apiError)
            throw apiError
        } catch {
            let apiError = APIError.requestFailed(error)
            APILogger.logError(apiError)
            throw apiError
        }
    }

    func requestString(_ endpoint: APIEndpoint) async throws -> String {
        let data = try await requestData(endpoint)
        return String(data: data, encoding: .utf8) ?? ""
    }

    func requestVoid(_ endpoint: APIEndpoint) async throws {
        _ = try await requestData(endpoint)
    }

    func get<T: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        as responseType: T.Type = T.self
    ) async throws -> T {
        try await request(
            APIEndpoint(path: path, method: .get, queryItems: queryItems, headers: headers),
            as: responseType
        )
    }

    func post<T: Decodable, Body: Encodable>(
        _ path: String,
        body: Body,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        as responseType: T.Type = T.self
    ) async throws -> T {
        try await request(
            APIEndpoint.json(path: path, method: .post, body: body, queryItems: queryItems, headers: headers),
            as: responseType
        )
    }

    func put<T: Decodable, Body: Encodable>(
        _ path: String,
        body: Body,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        as responseType: T.Type = T.self
    ) async throws -> T {
        try await request(
            APIEndpoint.json(path: path, method: .put, body: body, queryItems: queryItems, headers: headers),
            as: responseType
        )
    }

    func patch<T: Decodable, Body: Encodable>(
        _ path: String,
        body: Body,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        as responseType: T.Type = T.self
    ) async throws -> T {
        try await request(
            APIEndpoint.json(path: path, method: .patch, body: body, queryItems: queryItems, headers: headers),
            as: responseType
        )
    }

    func delete<T: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        as responseType: T.Type = T.self
    ) async throws -> T {
        try await request(
            APIEndpoint(path: path, method: .delete, queryItems: queryItems, headers: headers),
            as: responseType
        )
    }

    private func makeURLRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        let sanitizedPath = endpoint.path.hasPrefix("/") ? String(endpoint.path.dropFirst()) : endpoint.path
        let url = configuration.baseURL.appending(path: sanitizedPath)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL(url.absoluteString)
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let finalURL = components.url else {
            throw APIError.invalidURL(url.absoluteString)
        }

        var request = URLRequest(url: finalURL, timeoutInterval: configuration.timeoutInterval)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        configuration.defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        return request
    }

    private func validate(statusCode: Int, data: Data, response: HTTPURLResponse) throws {
        switch statusCode {
        case 200...299:
            return
        case 100...199:
            throw APIError.informational(statusCode: statusCode, data: data)
        case 300...399:
            let location = response.value(forHTTPHeaderField: "Location")
            throw APIError.redirection(statusCode: statusCode, location: location, data: data)
        case 401:
            throw APIError.unauthorized(message: errorMessage(from: data))
        case 403:
            throw APIError.forbidden(message: errorMessage(from: data))
        case 404:
            throw APIError.notFound(message: errorMessage(from: data))
        case 409:
            throw APIError.conflict(message: errorMessage(from: data))
        case 422:
            throw APIError.validationFailed(message: errorMessage(from: data))
        case 429:
            throw APIError.rateLimited(message: errorMessage(from: data))
        case 400...499:
            throw APIError.clientError(statusCode: statusCode, message: errorMessage(from: data), data: data)
        case 500...599:
            throw APIError.serverError(statusCode: statusCode, message: errorMessage(from: data), data: data)
        default:
            throw APIError.requestFailed(URLError(.badServerResponse))
        }
    }

    private func errorMessage(from data: Data) -> String? {
        guard !data.isEmpty else { return nil }
        return (try? decoder.decode(APIErrorResponse.self, from: data))?.readableMessage
            ?? String(data: data, encoding: .utf8)
    }
}
