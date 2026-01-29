//
//  VaultView.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import SwiftUI

struct VaultView: View {
    @EnvironmentObject private var store: VaultStore
    @State private var isPresentingAdd = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Vault")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(Color.primary)
                            Text("A calm record of what you own.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(Color.secondary)
                        }

                        if store.items.isEmpty {
                            EmptyStateView {
                                isPresentingAdd = true
                            }
                        } else {
                            VStack(spacing: 16) {
                                ForEach(store.items) { item in
                                    ItemCardView(item: item)
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingAdd = true
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
            }
            .navigationDestination(isPresented: $isPresentingAdd) {
                AddItemView()
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: "Add Item") {
                    isPresentingAdd = true
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(.ultraThinMaterial)
            }
        }
    }
}

struct EmptyStateView: View {
    let onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "archivebox")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.primary)

            VStack(alignment: .leading, spacing: 8) {
                Text("Your vault is empty.")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.primary)
                Text("Add your first item to keep a calm record of what you own, then tap Add Item to begin.")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.secondary)
            }

            PrimaryButton(title: "Add Item") {
                onAdd()
            }
        }
        .cardBackground()
    }
}

struct ItemCardView: View {
    let item: VaultItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primary)

            HStack(spacing: 8) {
                Text(item.collection.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.secondary)
                Text("•")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.secondary)
                Text(item.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.secondary)
            }
        }
        .cardBackground()
    }
}

#Preview {
    VaultView()
        .environmentObject(VaultStore())
}
