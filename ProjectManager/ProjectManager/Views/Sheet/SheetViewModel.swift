//
//  SheetViewModel.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/10/07.
//

import Foundation

final class SheetViewModel: ObservableObject {
    @Published var isEditMode: Bool
    @Published var memo: Memo

    init(
        isEditMode: Bool = true,
        memo: Memo = .init(
            title: "",
            body: "",
            deadline: .now,
            category: .toDo
        )
    ) {
        self.isEditMode = isEditMode
        self.memo = memo
    }
    
    func navigationLeftBtnTapped() {
        isEditMode.toggle()
    }
}
