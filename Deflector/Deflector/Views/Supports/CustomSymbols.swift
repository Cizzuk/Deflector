//
//  CustomSymbols.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/02.
//

import PhotosUI
import SwiftUI

struct CustomSymbols: View {
    @Binding var symbol: String
    
    @State private var customSymbols: [CustomSymbol] = []
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    struct CustomSymbol: Identifiable {
        var id: String
        var image: Image
    }
    
    private func loadCustomSymbols() {
        DispatchQueue.global(qos: .userInteractive).async {
            if let symbolNames = SymbolHelper.getCustomSymbolNames() {
                symbolNames.forEach { symbolName in
                    if customSymbols.first(where: { $0.id == symbolName }) == nil,
                       let image = SymbolHelper.getSymbolImage(symbolName).image {
                        DispatchQueue.main.async {
                            customSymbols.append(CustomSymbol(id: symbolName, image: image))
                        }
                    }
                }
            }
        }
    }
    
    private func handlePhotoPickerSelection(_ item: PhotosPickerItem) async {
        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data),
           let newSymbolName = SymbolHelper.saveCustomSymbol(image: uiImage) {
            symbol = newSymbolName
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            loadCustomSymbols()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(customSymbols) { item in
                    let isSelected = symbol == item.id
                    Button(action: { symbol = item.id }) {
                        HStack {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(isSelected ? .accent : .secondary)
                                .labelStyle(.iconOnly)
                            item.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(5)
                            Text(item.id)
                                .lineLimit(1)
                                .foregroundStyle(isSelected ? .accent : .secondary)
                        }
                        .accessibilityHidden(true)
                    }
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                    .accessibilityLabel("Custom Symbol")
                    .accessibilityValue(item.id)
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let symbolNameToDelete = customSymbols[index].id
                        if SymbolHelper.deleteCustomSymbol(symbolName: symbolNameToDelete) {
                            customSymbols.remove(at: index)
                            if symbol == symbolNameToDelete {
                                symbol = ""
                            }
                        }
                    }
                }
            }
            .navigationTitle("Custom Symbols")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { loadCustomSymbols() }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("Add New Symbol", systemImage: "plus")
                    }
                    .tint(Color(uiColor: .label))
                    .onChange(of: selectedPhoto) {
                        if let item = selectedPhoto {
                            Task { await handlePhotoPickerSelection(item) }
                        }
                        selectedPhoto = nil
                    }
                }
            }
        }
    }
}
