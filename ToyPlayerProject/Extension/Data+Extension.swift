//
//  Data+Extension.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation
extension String {
    func convert(from fromFormat: String, to toFormat: String) -> String {
        guard let date = convertDate(of: fromFormat) else {
            return self
        }
        let formatter = DateFormatter()
        formatter.dateFormat = toFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    func convertDate(of format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.isLenient = true
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.formatterBehavior = .default
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
