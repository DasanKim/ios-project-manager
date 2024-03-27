//
//  SheetViewModel.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/10/07.
//

import Foundation

final class SheetViewModel: ObservableObject {
    @Published var canEditable: Bool
    @Published var memo: Memo
    let memoManager: MemoManager
    var delegate: ViewUpdateDelegate?
    
    init(memo: Memo, canEditable: Bool, memoManager: MemoManager) {
        self.memo = memo
        self.canEditable = canEditable
        self.memoManager = memoManager
    }
    
    func save() {
        memoManager.save(memo)
        delegate?.update(memo)
    }
    
    func edit() {
        canEditable.toggle()
    }
    
    func cancel() {
        canEditable = true
    }
}

protocol ViewUpdateDelegate {
    func update(_ memo: Memo)
}
