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

    init(items: [VaultItem] = []) {
        self.items = items
    }

    func addItem(
        name: String,
        collection: VaultCollection,
        purchaseDate: Date? = nil,
        retailer: String = "",
        price: Decimal? = nil,
        warrantyProvider: String = "",
        warrantyNotes: String = "",
        warrantyEndDate: Date? = nil,
        serialNumber: String = "",
        modelNumber: String = "",
        identifierNotes: String = "",
        photoReferences: [URL] = []
    ) {
        let newItem = VaultItem(
            name: name,
            collection: collection,
            purchaseDate: purchaseDate,
            retailer: retailer,
            price: price,
            warrantyProvider: warrantyProvider,
            warrantyNotes: warrantyNotes,
            warrantyEndDate: warrantyEndDate,
            serialNumber: serialNumber,
            modelNumber: modelNumber,
            identifierNotes: identifierNotes,
            photoReferences: photoReferences
        )
        items.insert(newItem, at: 0)
    }

    func updateItem(_ item: VaultItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
    }

    static func mock() -> VaultStore {
        let receipt = VaultDocument(title: "Purchase Receipt", kind: .receipt, date: .now.addingTimeInterval(-86_400 * 240))
        let warranty = VaultDocument(title: "Warranty PDF", kind: .warranty, date: .now.addingTimeInterval(-86_400 * 200))
        let service = ServiceRecord(date: .now.addingTimeInterval(-86_400 * 40), note: "Replaced filter and tested seals.", cost: 89)

        let sampleItems = [
            VaultItem(
                name: "Breville Espresso Pro",
                collection: .appliances,
                purchaseDate: .now.addingTimeInterval(-86_400 * 320),
                retailer: "Williams Sonoma",
                price: 649,
                warrantyProvider: "Breville",
                warrantyNotes: "Registered for concierge coverage.",
                warrantyEndDate: .now.addingTimeInterval(86_400 * 365),
                serialNumber: "BRV-39284-22",
                modelNumber: "BES870XL",
                identifierNotes: "Keep packaging for service return.",
                documents: [receipt, warranty],
                serviceRecords: [service]
            ),
            VaultItem(
                name: "Sony WH-1000XM5",
                collection: .audio,
                purchaseDate: .now.addingTimeInterval(-86_400 * 120),
                retailer: "Best Buy",
                price: 399,
                warrantyProvider: "Sony",
                warrantyEndDate: .now.addingTimeInterval(86_400 * 180),
                serialNumber: "SNY-45810-11",
                modelNumber: "WH-1000XM5",
                identifierNotes: "Pairing instructions in the manual."
            )
        ]

        return VaultStore(items: sampleItems)
    }
}
