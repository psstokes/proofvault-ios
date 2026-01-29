//
//  PrroofVaultApp.swift
//  PrroofVault
//
//  Created by Home on 28/01/2026.
//

import SwiftUI

@main
struct PrroofVaultApp: App {
    @StateObject private var store = VaultStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
