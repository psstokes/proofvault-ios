//
//  AddItemView.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import SwiftUI

struct AddItemView: View {
    enum Mode: Equatable {
        case add
        case edit(VaultItem)

        var title: String {
            switch self {
            case .add:
                return "Add Item"
            case .edit:
                return "Edit Item"
            }
        }

        var subtitle: String {
            switch self {
            case .add:
                return "Capture what you own so warranties and receipts stay ready."
            case .edit:
                return "Update details so your record stays accurate."
            }
        }
    }

    @EnvironmentObject private var store: VaultStore
    @Environment(\.dismiss) private var dismiss

    let mode: Mode

    @State private var name = ""
    @State private var selectedCollection: VaultCollection?
    @State private var purchaseDate = Date()
    @State private var retailer = ""
    @State private var priceText = ""
    @State private var warrantyProvider = ""
    @State private var warrantyEndDate = Date()
    @State private var warrantyNotes = ""
    @State private var serialNumber = ""
    @State private var modelNumber = ""
    @State private var identifierNotes = ""

    init(mode: Mode) {
        self.mode = mode
        if case let .edit(item) = mode {
            _name = State(initialValue: item.name)
            _selectedCollection = State(initialValue: item.collection)
            _purchaseDate = State(initialValue: item.purchaseDate ?? Date())
            _retailer = State(initialValue: item.retailer)
            _priceText = State(initialValue: item.price.map { "\($0)" } ?? "")
            _warrantyProvider = State(initialValue: item.warrantyProvider)
            _warrantyEndDate = State(initialValue: item.warrantyEndDate ?? Date())
            _warrantyNotes = State(initialValue: item.warrantyNotes)
            _serialNumber = State(initialValue: item.serialNumber)
            _modelNumber = State(initialValue: item.modelNumber)
            _identifierNotes = State(initialValue: item.identifierNotes)
        }
    }

    private var isSaveEnabled: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedCollection != nil
    }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(mode.title)
                            .font(AppTypography.title)
                            .foregroundStyle(AppTheme.primaryText)
                        Text(mode.subtitle)
                            .font(AppTypography.subtitle)
                            .foregroundStyle(AppTheme.secondaryText)
                    }

                    CardSurface {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            SectionHeader("Photos", subtitle: "Add up to 6 photos for quick visual proof.")
                            Button {
                                // Placeholder for photo picker
                            } label: {
                                Label("Add Photo", systemImage: "photo.on.rectangle")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous)
                                            .strokeBorder(Color(.separator))
                                    )
                            }
                        }
                    }

                    CardSurface {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            SectionHeader("Core details", subtitle: "Tell us what it is and where it lives.")

                            TextFieldRow(title: "Name", placeholder: "e.g. KitchenAid Mixer", text: $name)

                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text("Collection")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(AppTheme.primaryText)
                                Text("Choose a collection so the vault stays tidy.")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppTheme.secondaryText)

                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: AppSpacing.sm)], spacing: AppSpacing.sm) {
                                    ForEach(VaultCollection.allCases) { collection in
                                        CollectionChip(
                                            title: collection.title,
                                            isSelected: selectedCollection == collection
                                        ) {
                                            selectedCollection = collection
                                        }
                                    }
                                }
                            }

                            DateFieldRow(title: "Purchase date", selection: $purchaseDate)
                            TextFieldRow(title: "Retailer", placeholder: "Where you bought it", text: $retailer)
                            TextFieldRow(title: "Price", placeholder: "$0.00", text: $priceText, keyboardType: .decimalPad)
                        }
                    }

                    CardSurface {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            SectionHeader("Warranty", subtitle: "Capture coverage so renewals stay simple.")
                            TextFieldRow(title: "Provider", placeholder: "Brand or retailer", text: $warrantyProvider)
                            DateFieldRow(title: "Warranty end", selection: $warrantyEndDate)
                            TextFieldRow(title: "Notes", placeholder: "What matters about this warranty", text: $warrantyNotes)
                        }
                    }

                    CardSurface {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            SectionHeader("Identifiers", subtitle: "Serials and models stay ready to copy.")
                            TextFieldRow(title: "Serial number", placeholder: "Enter serial", text: $serialNumber)
                            TextFieldRow(title: "Model", placeholder: "Model number", text: $modelNumber)
                            TextFieldRow(title: "Notes", placeholder: "Extra identifiers or tips", text: $identifierNotes)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, 120)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Save", isDisabled: !isSaveEnabled) {
                saveItem()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(.ultraThinMaterial)
        }
    }

    private func saveItem() {
        guard let collection = selectedCollection else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let price = Decimal(string: priceText)

        switch mode {
        case .add:
            store.addItem(
                name: trimmedName,
                collection: collection,
                purchaseDate: purchaseDate,
                retailer: retailer,
                price: price,
                warrantyProvider: warrantyProvider,
                warrantyNotes: warrantyNotes,
                warrantyEndDate: warrantyEndDate,
                serialNumber: serialNumber,
                modelNumber: modelNumber,
                identifierNotes: identifierNotes
            )
        case .edit(let item):
            let updatedItem = VaultItem(
                id: item.id,
                name: trimmedName,
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
                photoReferences: item.photoReferences,
                documents: item.documents,
                serviceRecords: item.serviceRecords
            )
            store.updateItem(updatedItem)
        }

        dismiss()
    }
}

struct TextFieldRow: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
                .keyboardType(keyboardType)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.tertiarySystemBackground))
                )
        }
    }
}

struct DateFieldRow: View {
    let title: String
    @Binding var selection: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            DatePicker("", selection: $selection, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct CollectionChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isSelected ? Color(.systemBackground) : AppTheme.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.chip, style: .continuous)
                        .fill(isSelected ? Color(.label) : Color(.secondarySystemBackground))
                )
        }
    }
}

#Preview {
    NavigationStack {
        AddItemView(mode: .add)
            .environmentObject(VaultStore.mock())
    }
}
