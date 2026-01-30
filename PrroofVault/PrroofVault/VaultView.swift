//
//  VaultView.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import SwiftUI
import UIKit

struct VaultView: View {
    @EnvironmentObject private var store: VaultStore
    @State private var isPresentingAdd = false
    @State private var searchText = ""
    @State private var selectedCollection: VaultCollection?

    private var filteredItems: [VaultItem] {
        store.items.filter { item in
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            let matchesCollection = selectedCollection == nil || item.collection == selectedCollection
            return matchesSearch && matchesCollection
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.section) {
                        VaultHeaderView()

                        if !store.items.isEmpty {
                            CollectionFilterView(selectedCollection: $selectedCollection)
                        }

                        if filteredItems.isEmpty {
                            EmptyStateView {
                                isPresentingAdd = true
                            }
                        } else {
                            LazyVStack(spacing: AppSpacing.lg) {
                                ForEach(filteredItems) { item in
                                    NavigationLink(value: item.id) {
                                        ItemCardView(item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAdd = true
                    } label: {
                        Label(AppStrings.addItem, systemImage: "plus")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search your vault")
            .navigationDestination(isPresented: $isPresentingAdd) {
                AddItemView(mode: .add)
            }
            .navigationDestination(for: VaultItem.ID.self) { itemID in
                ItemDetailView(itemID: itemID)
            }
        }
    }
}

struct VaultHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(AppStrings.vaultTitle)
                .font(AppTypography.title)
                .foregroundStyle(AppTheme.primaryText)
            Text(AppStrings.vaultSubtitle)
                .font(AppTypography.subtitle)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }
}

struct EmptyStateView: View {
    let onAdd: () -> Void

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Image(systemName: "archivebox")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Your vault is empty.")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(AppTheme.primaryText)
                    Text("Add your first item so you can keep a calm record of what you own, then start capturing receipts and warranties.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppTheme.secondaryText)
                }

                PrimaryButton(title: AppStrings.addYourFirstItem) {
                    onAdd()
                }
            }
        }
    }
}

struct CollectionFilterView: View {
    @Binding var selectedCollection: VaultCollection?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                FilterChip(title: "All", isSelected: selectedCollection == nil) {
                    selectedCollection = nil
                }

                ForEach(VaultCollection.allCases) { collection in
                    FilterChip(title: collection.title, isSelected: selectedCollection == collection) {
                        selectedCollection = collection
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isSelected ? Color(.systemBackground) : AppTheme.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.chip, style: .continuous)
                        .fill(isSelected ? Color(.label) : Color(.secondarySystemBackground))
                )
        }
    }
}

struct ItemCardView: View {
    let item: VaultItem

    var body: some View {
        CardSurface {
            HStack(alignment: .top, spacing: AppSpacing.md) {
                ItemThumbnailView()

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(item.name)
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppTheme.primaryText)

                    Text(item.collection.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)

                    HStack(spacing: AppSpacing.xs) {
                        StatusChip(title: item.warrantyStatus.rawValue, style: item.warrantyStatus.chipStyle)
                        if !item.documents.isEmpty {
                            StatusChip(title: "Receipt attached")
                        }
                    }
                }

                Spacer()
            }
        }
    }
}

struct ItemThumbnailView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color(.secondarySystemBackground))
            .frame(width: 64, height: 64)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(AppTheme.secondaryText)
            )
    }
}

struct ItemDetailView: View {
    @EnvironmentObject private var store: VaultStore
    @State private var isPresentingEdit = false
    let itemID: VaultItem.ID

    private var item: VaultItem? {
        store.items.first(where: { $0.id == itemID })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                if let item {
                    heroSection(for: item)
                    documentsSection(for: item)
                    serviceSection(for: item)
                    identifiersSection(for: item)
                    actionSection(for: item)
                } else {
                    CardSurface {
                        Text("This item is no longer available.")
                            .font(AppTypography.body)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxl)
        }
        .background(AppTheme.background)
        .navigationTitle(item?.name ?? "Item Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPresentingEdit) {
            if let item {
                NavigationStack {
                    AddItemView(mode: .edit(item))
                }
            }
        }
    }

    private func heroSection(for item: VaultItem) -> some View {
        CardSurface {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                ItemThumbnailView()
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: AppSpacing.sm) {
                    Text(item.name)
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppTheme.primaryText)

                    StatusChip(title: item.collection.title)
                    StatusChip(title: item.warrantyStatus.rawValue, style: item.warrantyStatus.chipStyle)
                }

                HStack(spacing: AppSpacing.lg) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchased")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                        Text(item.purchaseDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not set")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AppTheme.primaryText)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Warranty end")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                        Text(item.warrantyEndDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not set")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AppTheme.primaryText)
                    }
                }
            }
        }
    }

    private func documentsSection(for item: VaultItem) -> some View {
        CardSurface {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader("Documents", subtitle: "Receipts and warranties stay close to this item.")

                if item.documents.isEmpty {
                    Text("No documents yet. Add a receipt so proof is ready when you need it.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppTheme.secondaryText)
                } else {
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(item.documents) { document in
                            Button {
                                // Placeholder for opening document
                            } label: {
                                DocumentRow(document: document)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private func serviceSection(for item: VaultItem) -> some View {
        CardSurface {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader("Service & Repairs", subtitle: "Track what happened and what it cost.")

                if item.serviceRecords.isEmpty {
                    Text("No service history yet. Add a repair so future visits are easy.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppTheme.secondaryText)
                } else {
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(item.serviceRecords) { record in
                            ServiceRecordRow(record: record)
                        }
                    }
                }
            }
        }
    }

    private func identifiersSection(for item: VaultItem) -> some View {
        CardSurface {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader("Identifiers", subtitle: "Serials and models stay copy-ready.")

                IdentifierRow(title: "Serial Number", value: item.serialNumber)
                IdentifierRow(title: "Model", value: item.modelNumber)
                IdentifierRow(title: "Retailer", value: item.retailer)
                IdentifierRow(title: "Notes", value: item.identifierNotes)
            }
        }
    }

    private func actionSection(for item: VaultItem) -> some View {
        CardSurface {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Button {
                    // Placeholder for document flow
                } label: {
                    Label("Add Document", systemImage: "doc.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }

                Button {
                    // Placeholder for repair flow
                } label: {
                    Label("Add Repair", systemImage: "wrench.and.screwdriver")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }

                PrimaryButton(title: "Edit Item") {
                    isPresentingEdit = true
                }
            }
        }
    }
}

struct DocumentRow: View {
    let document: VaultDocument

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(document.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Text(document.kind.rawValue)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }
            Spacer()
            Text(document.date.formatted(date: .abbreviated, time: .omitted))
                .font(AppTypography.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(AppSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.tertiarySystemBackground))
        )
    }
}

struct ServiceRecordRow: View {
    let record: ServiceRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(record.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Spacer()
                if let cost = record.cost {
                    Text(NumberFormatter.currency.string(from: cost as NSDecimalNumber) ?? "$0")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.primaryText)
                }
            }
            Text(record.note)
                .font(AppTypography.body)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(AppSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.tertiarySystemBackground))
        )
    }
}

struct IdentifierRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                Text(value.isEmpty ? "Not set" : value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
            }
            Spacer()
            Button {
                UIPasteboard.general.string = value
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppTheme.secondaryText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                    )
            }
            .disabled(value.isEmpty)
        }
        .padding(.vertical, 4)
    }
}

extension NumberFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

#Preview {
    VaultView()
        .environmentObject(VaultStore.mock())
}
