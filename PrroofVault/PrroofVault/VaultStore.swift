//
//  VaultStore.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import Foundation

@MainActor
final class VaultStore: ObservableObject {
    @Published private(set) var items: [VaultItem] = []

    func addItem(title: String, collection: VaultCollection) {
        let newItem = VaultItem(title: title, collection: collection)
        items.insert(newItem, at: 0)
    }
}
