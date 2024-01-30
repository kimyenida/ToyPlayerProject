//
//  String+Extension.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/23/24.
//

import Foundation


extension String {
    func applySSL() -> String {
        return self.replacingOccurrences(of: "http:", with: "https:")
    }
    
    func subString(startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - self.count) + 1
        let indexStartOfText = self.index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = self.index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
    
    func removeZerosAtFront() -> String {
        guard self.hasPrefix("0") else { return self }
        let prefixCount = self.prefix { $0 == "0" }.count
        return String(self.dropFirst(prefixCount))
    }
}
