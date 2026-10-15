//
//  AppClipRouter.swift
//  QuickCoffeeClip
//
//  Created by Devendra Kumar on 02/09/26.
//

import Foundation
import Observation

@Observable
final class AppClipRouter {
    var shopID: String?
    var tableID: String?

    func handle(url: URL) {
        print("🔥 URL:", url.absoluteString)

        let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )

        let queryItems = components?.queryItems ?? []
        let pathComponents = url.pathComponents.filter { $0 != "/" }

        shopID = value(
            for: ["shop", "s"],
            queryItems: queryItems,
            pathComponents: pathComponents
        )

        tableID = value(
            for: ["table", "t"],
            queryItems: queryItems,
            pathComponents: pathComponents
        )

        print("🔥 SHOP:", shopID ?? "nil")
        print("🔥 TABLE:", tableID ?? "nil")
    }

    private func value(
        for keys: [String],
        queryItems: [URLQueryItem],
        pathComponents: [String]
    ) -> String? {
        if let queryValue = queryItems.first(where: { keys.contains($0.name) })?.value {
            return queryValue
        }

        for (index, component) in pathComponents.enumerated() where keys.contains(component.lowercased()) {
            let nextIndex = pathComponents.index(after: index)
            if nextIndex < pathComponents.endIndex {
                return pathComponents[nextIndex]
            }
        }

        return nil
    }
}
