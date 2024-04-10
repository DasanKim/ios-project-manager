//
//  MemoHomeViewModel.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/10/07.
//

import Foundation

final class MemoHomeViewModel: ObservableObject {
    @Published var isDisplaySheet: Bool = false
    
    func plusBtnTapped() {
        isDisplaySheet.toggle()
    }
}
