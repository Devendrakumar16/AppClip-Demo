//
//  CoffeeItem.swift
//  APPCLIP
//
//  Created by Devendra Kumar on 02/09/26.
//

import Foundation

struct CoffeeItem: Codable, Identifiable{
    let id: Int
    let name:String
    let price:Double
    let description:String
    
    
}


struct CoffeeMenu{
    static let items = [
            CoffeeItem(
                id: 1,
                name: "Cappuccino",
                price: 150,
                description: "Espresso with steamed milk and foam"
            ),
            CoffeeItem(
                id: 2,
                name: "Latte",
                price: 170,
                description: "Smooth espresso with steamed milk"
            ),
            CoffeeItem(
                id: 3,
                name: "Americano",
                price: 120,
                description: "Espresso with hot water"
            )
        ]
}
