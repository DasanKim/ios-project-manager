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
            .locale(Locale.current.regionCode == "KR" ?
                    Locale(identifier: "ko_KR")
                    : Locale(identifier: "en_EH"))
        
        return self.formatted(myFormat)
    }
}
