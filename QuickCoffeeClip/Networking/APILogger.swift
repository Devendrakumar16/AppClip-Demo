//
//  APILogger.swift
//  QuickCoffeeClip
//

import Foundation

enum APILogger {
    static func logRequest(_ request: URLRequest) {
        print("\n[API Request]")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")

        if let body = request.httpBody, !body.isEmpty {
            print("Body: \(prettyPrinted(data: body))")
        }
    }

    static func logResponse(data: Data, response: HTTPURLResponse) {
        print("\n[API Response]")
        print("URL: \(response.url?.absoluteString ?? "nil")")
        print("Status Code: \(response.statusCode)")
        print("Headers: \(response.allHeaderFields)")
        print("Body: \(prettyPrinted(data: data))")
    }

    static func logError(_ error: Error) {
        print("\n[API Error]")
        print(error.localizedDescription)
    }

    private static func prettyPrinted(data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }

        return String(data: data, encoding: .utf8) ?? "<\(data.count) bytes>"
    }
}
