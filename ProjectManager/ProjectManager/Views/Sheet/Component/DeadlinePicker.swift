//
//  DeadlinePicker.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/09/28.
//

import SwiftUI

struct DeadlinePicker: View {
    @Binding var date: Date
    
    var body: some View {
        DatePicker("deadline", selection: $date, displayedComponents: .date)
            .labelsHidden()
            .datePickerStyle(.wheel)
            .environment(\.locale, Locale(identifier: NSLocale.preferredLanguages.first ?? "ko_KR"))
    }
}

struct DeadlinePicker_Previews: PreviewProvider {
    static var previews: some View {
        DeadlinePicker(date: .constant(DummyMemo.memos[0].deadline))
    }
}
