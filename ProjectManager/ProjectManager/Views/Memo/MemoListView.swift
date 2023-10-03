//
//  MemoListView.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/09/22.
//

import SwiftUI

struct MemoListView: View {
    @State private var currentMemo: Memo? = nil
    private var memos: [Memo]
    private var category: Memo.Category
    
    init(memos: [Memo], category: Memo.Category) {
        self.memos = memos
        self.category = category
    }

    var body: some View {
        VStack(spacing: 0) {
            ListHeader(category: category.description, memoCount: memos.count)
            
            List {
                ForEach(memos) { memo in
                    VStack(alignment: .leading, spacing: 2) {
                        HorizontalSpacing()
                        
                        MemoRow(memo: memo)
                            .swipeActions {
                                Button {
                                    // Delete
                                } label: {
                                    Text("Delete")
                                }
                            }
                            .padding()
                        
                        HorizontalDivider()
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .contentShape(Rectangle())
                    .onTapGesture {
                        currentMemo = memo
                    }
                }
                .sheet(item: $currentMemo) { memo in
                    MemoDetail(memo: memo)
                }
            }
            .background(ColorSet.background)
            .listStyle(.plain)
        }
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView(memos: ModelData().toDoList, category: .doing)
    }
}
