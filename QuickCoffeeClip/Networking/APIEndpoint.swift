//
//  APIEndpoint.swift
//  QuickCoffeeClip
//

import Foundation

struct APIEndpoint {
    let path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var body: Data?

    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}

extension APIEndpoint {
    static var coffeeMenu: APIEndpoint {
        APIEndpoint(path: "/coffee/menu", method: .get)
    }

    static func json<Body: Encodable>(
        path: String,
        method: HTTPMethod,
        body: Body,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> APIEndpoint {
        var requestHeaders = headers
        requestHeaders["Content-Type"] = requestHeaders["Content-Type"] ?? "application/json"

        return APIEndpoint(
            path: path,
            method: method,
            queryItems: queryItems,
            headers: requestHeaders,
            body: try encoder.encode(body)
        )
    }
}
