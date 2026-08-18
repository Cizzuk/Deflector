//
//  SymbolPicker.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/18.
//

import SwiftUI

struct SymbolPicker: View {
    @Environment(\.dismiss) var dismiss
    
    @State var symbol: String
    var callback: (String) -> Void
    
    init(_ symbol: String, callback: @escaping (String) -> Void) {
        self.symbol = symbol
        self.callback = callback
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: symbol)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding()
                            .accessibilityHidden(true)
                        Spacer()
                    }
                    TextField("Symbol", text: $symbol)
                        .submitLabel(.done)
                }
            }
            .navigationTitle("Choose Symbol")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        callback(symbol)
                        dismiss()
                    }) {
                        Label("Done", systemImage: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
    }
}
