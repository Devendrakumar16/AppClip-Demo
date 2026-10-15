//
//  ContentView.swift
//  QuickCoffeeClip
//
//  Created by Devendra Kumar on 02/09/26.
//

import SwiftUI

struct ContentView: View {
    let router: AppClipRouter

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Quick Coffee")
                    .font(.largeTitle.bold())

                if let shopID = router.shopID,
                   let tableID = router.tableID {
                    Text("Shop: \(shopID)")

                    Text("Table: \(tableID)")
                        .font(.title2.bold())
                } else {
                    Text("No table information")
                        .foregroundStyle(.secondary)
                }

                Divider()

                NavigationLink {
                    CoffeeMenuAPIScreen()
                } label: {
                    Label("Load Menu From API", systemImage: "network")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                List(CoffeeMenu.items) { coffee in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(coffee.name)
                                .font(.headline)

                            Text(coffee.description)
                                .font(.caption)
                        }

                        Spacer()

                        Text("₹\(coffee.price, specifier: "%.0f")")
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView(router: AppClipRouter())
}
