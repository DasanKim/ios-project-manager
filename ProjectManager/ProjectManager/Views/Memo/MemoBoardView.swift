//
//  MemoBoardView.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2024/04/09.
//

import SwiftUI

struct MemoBoardView: View {
    @EnvironmentObject private var memoBoardViewModel: MemoBoardViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(Category.allCases, id: \.description) { category in
                MemoListView(
                    memoListViewModel: MemoListViewModel(
                        memos: memoBoardViewModel.filter(by: category),
                        category: category
                    )
                )
            }
        }
    }
}

struct MemoBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MemoBoardView()
    }
}
