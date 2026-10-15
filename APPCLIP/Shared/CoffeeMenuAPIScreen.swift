//
//  CoffeeMenuAPIScreen.swift
//  APPCLIP
//

import SwiftUI

struct CoffeeMenuAPIScreen: View {
    @State private var viewModel = CoffeeMenuViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.items.isEmpty {
                loadingView
            } else if let errorMessage = viewModel.errorMessage, viewModel.items.isEmpty {
                errorView(message: errorMessage)
            } else if viewModel.items.isEmpty && viewModel.hasLoaded {
                emptyView
            } else {
                menuList
            }
        }
        .navigationTitle("API Coffee Menu")
        .task {
            if !viewModel.hasLoaded {
                await viewModel.loadMenu()
            }
        }
        .refreshable {
            await viewModel.reloadMenu()
        }
    }

    private var menuList: some View {
        List(viewModel.items) { coffee in
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(coffee.name)
                        .font(.headline)

                    Spacer()

                    Text("₹\(coffee.price, specifier: "%.0f")")
                        .font(.headline)
                }

                Text(coffee.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
        .overlay(alignment: .top) {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 12)
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading menu")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label("Unable to Load Menu", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.reloadMenu()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            "No Menu Items",
            systemImage: "cup.and.saucer",
            description: Text("The API returned an empty list.")
        )
    }
}

#Preview {
    NavigationStack {
        CoffeeMenuAPIScreen()
    }
}
