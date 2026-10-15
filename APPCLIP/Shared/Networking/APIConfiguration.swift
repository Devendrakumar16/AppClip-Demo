//
//  APIConfiguration.swift
//  APPCLIP
//

import Foundation

struct APIConfiguration {
    let baseURL: URL
    var defaultHeaders: [String: String]
    var timeoutInterval: TimeInterval
    var logsNetworkResponses: Bool

    init(
        baseURL: URL,
        defaultHeaders: [String: String] = [:],
        timeoutInterval: TimeInterval = 30,
        logsNetworkResponses: Bool = true
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeoutInterval = timeoutInterval
        self.logsNetworkResponses = logsNetworkResponses
    }
}

enum APIEnvironment {
    // Replace this with your production base URL, for example: https://api.yourdomain.com
    static let baseURL = URL(string: "https://api.example.com")!

    static let configuration = APIConfiguration(
        baseURL: baseURL,
        defaultHeaders: [
            "Accept": "application/json"
        ]
    )
}
