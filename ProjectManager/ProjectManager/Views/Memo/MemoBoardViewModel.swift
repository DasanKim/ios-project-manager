//
//  MemoBoardViewModel.swift
//  ProjectManager
//
//  Created by MARY on 2024/04/09.
//

import Foundation

final class MemoBoardViewModel: ObservableObject {
    @Published var memos: [Memo]
    let categories = Category.allCases
    
    init(memos: [Memo] = []) {
        self.memos = memos
    }
    
    func filter(by category: Category) -> [Memo] {
        memos.filter { $0.category == category }
    }
    
    func save(_ memo: Memo) {
        guard let index = memos.firstIndex(where: { $0.id == memo.id }) else {
            memos.append(memo)
            return
        }
        memos[index] = memo
    }
    
    func delete(_ memo: Memo) {
        guard let index = memos.firstIndex(where: { $0.id == memo.id }) else {
            return
        }
        memos.remove(at: index)
    }
    
    func move(_ memo: Memo, destination: Category) {
        guard let index = memos.firstIndex(where: { $0.id == memo.id }) else {
            return
        }
        memos[index].category = destination
    }
    
    func getFirstDestination(from category: Category) -> Category {
        return Category.allCases.filter { $0 != category }[0]
    }
    
    func getSecondDestination(from category: Category) -> Category {
        return Category.allCases.filter { $0 != category }[1]
    }
}
