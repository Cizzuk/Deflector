//
//  SymbolHelper.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/02.
//

import SwiftUI

class SymbolHelper {
    enum SymbolType: String {
        case custom, cizzuk
        case system
        case none, unknown
        
        var prefix: String {
            switch self {
            case .custom: return ".custom."
            case .cizzuk: return ".cizzuk."
            case .system: return ""
            case .none: return ""
            case .unknown: return ""
            }
        }
        
        var isPicture: Bool {
            switch self {
            case .custom: return true
            case .cizzuk: return false
            case .system: return false
            case .none: return false
            case .unknown: return false
            }
        }
    }
    
    static func customSymbolDirURL() -> URL? {
        guard let groupContainerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else { return nil }
        
        let itemURL = groupContainerURL.appending(path: "custom_symbols", directoryHint: .isDirectory)
        
        return itemURL
    }
        
    static func getSymbolImage(_ symbolName: String) -> (image: Image?, type: SymbolType) {
        if symbolName.isEmpty {
            return (Image(systemName: "square.dashed"), .none)
        }
        
        if symbolName.hasPrefix(SymbolType.custom.prefix),
           let customSymbolDirURL = customSymbolDirURL() {
            let symbolFileURL = customSymbolDirURL.appending(path: symbolName, directoryHint: .notDirectory)
            if let uiImage = UIImage(contentsOfFile: symbolFileURL.path()) {
                return (Image(uiImage: uiImage), .custom)
            }
        } else if symbolName.hasPrefix(SymbolType.cizzuk.prefix) {
            let availableSymbols = ["alare", "bolt.alare", "cbnote", "checkmark.alare", "cse.emoji", "cse.private", "cse.quick", "cse", "sidebridge", "sidefish"]
            let strippedSymbolName = String(symbolName.dropFirst(SymbolType.cizzuk.prefix.count))
            if availableSymbols.contains(strippedSymbolName) {
                return (Image(strippedSymbolName), .cizzuk)
            }
        }
        
        if UIImage(systemName: symbolName) != nil {
            return (Image(systemName: symbolName), .system)
        }
        
        return (Image(systemName: "questionmark.square.dashed"), .unknown)
    }
    
    static func getCustomSymbolNames() -> [String]? {
        guard let customSymbolDirURL = customSymbolDirURL(),
              let fileURLs = try? FileManager.default.contentsOfDirectory(at: customSymbolDirURL, includingPropertiesForKeys: nil)
        else { return nil }
        
        let symbolNames = fileURLs.compactMap { $0.lastPathComponent }
        return symbolNames
    }
    
    static func saveCustomSymbol(image: UIImage) -> String? {
        guard let customSymbolDirURL = customSymbolDirURL() else { return nil }
        
        try? FileManager.default.createDirectory(at: customSymbolDirURL, withIntermediateDirectories: true, attributes: nil)
        
        let symbolName = "\(SymbolType.custom.prefix)\(UUID().uuidString)"
        let symbolFileURL = customSymbolDirURL.appending(path: symbolName, directoryHint: .notDirectory)
        
        let resizedImage = resize(image: image, target: CGSize(width: 200, height: 200))
        
        if let imageData = resizedImage.pngData() {
            do {
                try imageData.write(to: symbolFileURL)
                return symbolName
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    static func deleteCustomSymbol(symbolName: String) -> Bool {
        guard let customSymbolDirURL = customSymbolDirURL() else { return false }
        
        let symbolFileURL = customSymbolDirURL.appending(path: symbolName, directoryHint: .notDirectory)
        
        if FileManager.default.fileExists(atPath: symbolFileURL.path()) {
            do {
                try FileManager.default.removeItem(at: symbolFileURL)
                return true
            } catch {
                return false
            }
        }
        
        return false
    }
    
    static func resize(image: UIImage, target: CGSize) -> UIImage {
        let w = image.size.width
        let h = image.size.height

        if w <= target.width && h <= target.height {
            return image
        }

        let scale = min(target.width / w, target.height / h)
        let newSize = CGSize(width: w * scale, height: h * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale

        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let renderedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return renderedImage
    }
}
