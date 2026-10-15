//
//  CoffeeMenuViewModel.swift
//  APPCLIP
//

import Foundation
import Observation

@MainActor
@Observable
final class CoffeeMenuViewModel {
    private(set) var items: [CoffeeItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var hasLoaded = false

    func loadMenu() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let menuItems: [CoffeeItem] = try await APIClient.shared.request(APIEndpoint.coffeeMenu)
            items = menuItems
            hasLoaded = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func reloadMenu() async {
        hasLoaded = false
        await loadMenu()
    }
}
