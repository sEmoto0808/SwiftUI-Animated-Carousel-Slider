//
//  Food.swift
//  Carousel-Slider (iOS)
//
//  Created by Sho Emoto on 2022/01/01.
//

import Foundation

// Sample Data Model
struct Food: Identifiable {
    let id = UUID().uuidString
    let itemImage: String
    let itemTitle: String
}

let foods = [
    Food(itemImage: "food1", itemTitle: "Yummy Cake"),
    Food(itemImage: "food2", itemTitle: "Delicious Pizza"),
    Food(itemImage: "food3", itemTitle: "Yummy Loco Moco"),
]
