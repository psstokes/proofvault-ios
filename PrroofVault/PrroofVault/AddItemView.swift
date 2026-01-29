//
//  AddItemView.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import SwiftUI

struct AddItemView: View {
    @EnvironmentObject private var store: VaultStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var selectedCollection: VaultCollection?

    private var isSaveEnabled: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedCollection != nil
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Item")
                            .font(.system(size: 28, weight: .semibold))
                        Text("Give it a clear name and choose where it belongs.")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Title")
                            .font(.system(size: 16, weight: .semibold))
                        TextField("e.g. KitchenAid Mixer", text: $title)
                            .textInputAutocapitalization(.words)
                            .submitLabel(.done)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        Text("Use a name you will recognize later.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Collection")
                            .font(.system(size: 16, weight: .semibold))
                        Text("This keeps your vault tidy. Choose one to continue.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.secondary)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
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
                guard let collection = selectedCollection else { return }
                let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                store.addItem(title: trimmedTitle, collection: collection)
                dismiss()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
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
                .foregroundStyle(isSelected ? Color(.systemBackground) : Color.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSelected ? Color(.label) : Color(.secondarySystemBackground))
                )
        }
    }
}

#Preview {
    NavigationStack {
        AddItemView()
            .environmentObject(VaultStore())
    }
}
