//
//  MemoBoardView.swift
//  ProjectManager
//
//  Created by MARY on 2024/04/09.
//

import SwiftUI

struct MemoBoardView: View {
    @StateObject private var memoBoardViewModel = MemoBoardViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        // category 별 memoListView
        HStack(spacing: 4) {
            ForEach(memoBoardViewModel.categories, id: \.description) { category in
                MemoListView(
                    category: category,
                    memos: memoBoardViewModel.filter(by: category)
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
