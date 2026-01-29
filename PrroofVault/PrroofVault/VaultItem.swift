//
//  VaultItem.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import Foundation

struct VaultItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let collection: VaultCollection
    let createdAt: Date

    init(id: UUID = UUID(), title: String, collection: VaultCollection, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.collection = collection
        self.createdAt = createdAt
    }
}

enum VaultCollection: String, CaseIterable, Identifiable {
    case appliances = "Appliances"
    case tech = "Tech"
    case homeAndFurniture = "Home & Furniture"
    case tools = "Tools"
    case outdoor = "Outdoor"
    case other = "Other"

    var id: String { rawValue }

    var title: String { rawValue }
}
