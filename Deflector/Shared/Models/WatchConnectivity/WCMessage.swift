//
//  WCMessage.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Foundation

struct WCMessage: Codable {
    var method: Method
    
    enum Method: Codable {
        case requestApplicationContext
        case deflection(shortcutName: String)
    }
    
    init(method: Method) {
        self.method = method
    }
    
    init(_ dictionary: [String: Any]) throws {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let context = try decoder.decode(WCMessage.self, from: data)
        self = context
    }
    
    func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}
