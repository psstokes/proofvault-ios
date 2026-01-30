//
//  VaultItem.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import Foundation

struct VaultItem: Identifiable, Hashable {
    let id: UUID
    var name: String
    var collection: VaultCollection
    var purchaseDate: Date?
    var retailer: String
    var price: Decimal?
    var warrantyProvider: String
    var warrantyNotes: String
    var warrantyEndDate: Date?
    var serialNumber: String
    var modelNumber: String
    var identifierNotes: String
    var photoReferences: [URL]
    var documents: [VaultDocument]
    var serviceRecords: [ServiceRecord]

    init(
        id: UUID = UUID(),
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
        photoReferences: [URL] = [],
        documents: [VaultDocument] = [],
        serviceRecords: [ServiceRecord] = []
    ) {
        self.id = id
        self.name = name
        self.collection = collection
        self.purchaseDate = purchaseDate
        self.retailer = retailer
        self.price = price
        self.warrantyProvider = warrantyProvider
        self.warrantyNotes = warrantyNotes
        self.warrantyEndDate = warrantyEndDate
        self.serialNumber = serialNumber
        self.modelNumber = modelNumber
        self.identifierNotes = identifierNotes
        self.photoReferences = photoReferences
        self.documents = documents
        self.serviceRecords = serviceRecords
    }

    var warrantyStatus: WarrantyStatus {
        guard let warrantyEndDate else { return .unknown }
        return warrantyEndDate >= Date() ? .active : .expired
    }
}

struct VaultDocument: Identifiable, Hashable {
    let id: UUID
    var title: String
    var kind: DocumentKind
    var date: Date
    var url: URL?

    init(id: UUID = UUID(), title: String, kind: DocumentKind, date: Date = Date(), url: URL? = nil) {
        self.id = id
        self.title = title
        self.kind = kind
        self.date = date
        self.url = url
    }
}

enum DocumentKind: String, CaseIterable, Hashable {
    case receipt = "Receipt"
    case warranty = "Warranty"
    case manual = "Manual"
    case other = "Other"
}

struct ServiceRecord: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var note: String
    var cost: Decimal?
    var attachments: [VaultDocument]

    init(id: UUID = UUID(), date: Date, note: String, cost: Decimal? = nil, attachments: [VaultDocument] = []) {
        self.id = id
        self.date = date
        self.note = note
        self.cost = cost
        self.attachments = attachments
    }
}

enum WarrantyStatus: String, CaseIterable {
    case active = "Warranty Active"
    case expired = "Warranty Expired"
    case unknown = "Warranty Unknown"

    var chipStyle: StatusChip.ChipStyle {
        switch self {
        case .active:
            return .positive
        case .expired:
            return .warning
        case .unknown:
            return .neutral
        }
    }
}

enum VaultCollection: String, CaseIterable, Identifiable {
    case appliances = "Appliances"
    case tech = "Tech"
    case homeAndFurniture = "Home & Furniture"
    case tools = "Tools"
    case outdoor = "Outdoor"
    case audio = "Audio"
    case other = "Other"

    var id: String { rawValue }

    var title: String { rawValue }
}
