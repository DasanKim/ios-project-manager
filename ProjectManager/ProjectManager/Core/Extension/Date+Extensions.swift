//
//  Date+Extensions.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2024/04/11.
//

import Foundation

extension Date {
    var formattedDate: String {
        let myFormat = Date.FormatStyle()
            .year()
            .day()
            .month()
            .locale(Locale(identifier: NSLocale.preferredLanguages.first ?? "ko_KR"))
        
        return self.formatted(myFormat)
    }
}
