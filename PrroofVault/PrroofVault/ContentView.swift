//
//  ContentView.swift
//  PrroofVault
//
//  Created by Home on 28/01/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VaultView()
    }
}

#Preview {
    ContentView()
        .environmentObject(VaultStore())
}
