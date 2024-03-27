//
//  MemoListViewModel.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/10/07.
//

import Foundation

final class MemoListViewModel: ObservableObject, ViewUpdateDelegate {
    @Published var memos: [Memo]
    @Published var selectedMemo: Memo? = nil
    let memoManager: MemoManager
    let category: Memo.Category
    
    init(category: Memo.Category, memoManager: MemoManager) {
        self.category = category
        self.memoManager = memoManager
        memos = memoManager.filter(by: category)
    }
    
    func setSelectedMemo(_ memo: Memo) {
        selectedMemo = memo
    }
    
    func delete(_ memo: Memo) {
        guard let index = memos.firstIndex(where: { $0.id == memo.id }) else {
            return
        }
        memos.remove(at: index)
        memoManager.delete(memo)
    }
    
    func update(_ memo: Memo) {
        guard let index = memos.firstIndex(where: { $0.id == memo.id }) else {
            return
        }
        memos[index] = memo
    }
}