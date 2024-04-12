//
//  MemoListViewModel.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/10/07.
//

import Foundation

final class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    let category: Category

    init(
        memos: [Memo] = [],
        category: Category = .toDo
    ) {
        self.memos = memos
        self.category = category
    }
    
    func checkDeadlineExpired(memo: Memo) -> Bool {
        if (memo.category == .toDo || memo.category == .doing),
           (Calendar.current.compare(memo.deadline, to: .now, toGranularity: .day) == .orderedAscending) {
            return true
        }
        return false
    }
}
