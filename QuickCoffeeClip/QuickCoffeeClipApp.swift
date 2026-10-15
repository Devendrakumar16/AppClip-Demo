//
//  QuickCoffeeClipApp.swift
//  QuickCoffeeClip
//
//  Created by Devendra Kumar on 02/09/26.
//

import SwiftUI

@main
struct QuickCoffeeClipApp: App {
    @State private var router: AppClipRouter

    init() {
        let router = AppClipRouter()

        if let debugURL = Self.debugInvocationURL {
            router.handle(url: debugURL)
        }

        _router = State(initialValue: router)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(router: router)
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let url = userActivity.webpageURL else { return }
                    router.handle(url: url)
                }
                .onOpenURL { url in
                    router.handle(url: url)
                }
        }
    }

    private static var debugInvocationURL: URL? {
        guard let rawURL = ProcessInfo.processInfo.environment["_XCAppClipURL"] else {
            return nil
        }

        return URL(string: rawURL)
    }
}
