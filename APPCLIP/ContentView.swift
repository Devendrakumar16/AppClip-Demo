//
//  ContentView.swift
//  APPCLIP
//
//  Created by Devendra Kumar on 02/09/26.
//

import SwiftUI

struct ContentView: View {
    
    let coffeeItems = CoffeeMenu.items
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        CoffeeMenuAPIScreen()
                    } label: {
                        Label("Load Menu From API", systemImage: "network")
                    }
                }

                Section("Local Menu") {
                    ForEach(coffeeItems) { coffee in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
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
                }
            }
            .navigationTitle("Quick Coffee")
        }
    }
}

#Preview {
    ContentView()
}
