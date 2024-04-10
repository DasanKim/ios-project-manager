//
//  MemoListView.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/09/22.
//

import SwiftUI

struct MemoListView: View {
    @StateObject var memoListViewModel: MemoListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            TitleView(memoListViewModel: memoListViewModel)
            
            MemoListContentView(memoListViewModel: memoListViewModel)
                .background(ColorSet.background)
                .listStyle(.plain)
        }
    }
}

// MARK: - 카테고리 타이틀 뷰
private struct TitleView: View {
    @ObservedObject private var memoListViewModel: MemoListViewModel
    
    fileprivate init(memoListViewModel: MemoListViewModel) {
        self.memoListViewModel = memoListViewModel
    }
    
    fileprivate var body: some View {
        ListHeader(
            category: memoListViewModel.category.description,
            memoCount: memoListViewModel.memos.count
        )
    }
}

// MARK: - 리스트 컨텐츠 뷰
private struct MemoListContentView: View {
    @ObservedObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var memoBoardViewModel: MemoBoardViewModel
    
    fileprivate init(memoListViewModel: MemoListViewModel) {
        self.memoListViewModel = memoListViewModel
    }
    
    fileprivate var body: some View {
        List {
            ForEach(memoListViewModel.memos) { memo in
                MemoCellView(
                    memoListViewModel: memoListViewModel,
                    memo: memo
                )
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        memoBoardViewModel.delete(memo)
                    } label: {
                        Text("Delete")
                    }
                }
            }
        }
        .onChange(of: memoBoardViewModel.memos) { newValue in
            memoListViewModel.memos = newValue.filter { $0.category == memoListViewModel.category }
        }
    }
}

// MARK: - 메모 셀 뷰
private struct MemoCellView: View {
    @ObservedObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var memoBoardViewModel: MemoBoardViewModel
    var memo: Memo
    
    fileprivate init(
        memoListViewModel: MemoListViewModel,
        memo: Memo
    ) {
        self.memoListViewModel = memoListViewModel
        self.memo = memo
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HorizontalSpacing()
            
            VStack(alignment: .leading) {
                Text(memo.title)
                    .font(.title3)
                    .lineLimit(1)
                
                Text(memo.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                Text(memo.deadline.formatted(date: .numeric, time: .omitted))
                    .foregroundColor(memoListViewModel.checkDeadlineExpired(memo: memo) ? .red : .primary)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 30)
        }
        .listRowInsets(EdgeInsets())
        .contentShape(Rectangle())
        .onTapGesture {
            memoListViewModel.memoCellTapped(memo: memo)
        }
        .sheet(item: $memoListViewModel.selectedMemo) { memo in
            SheetView(
                sheetViewModel: SheetViewModel(
                    isEditMode: false,
                    memo: memo
                )
            )
        }
        .contextMenu {
            Button {
                memoBoardViewModel.move(memo, destination: memoBoardViewModel.getFirstDestination(from: memo.category))
            } label: {
                Text(memoBoardViewModel.getFirstDestination(from: memo.category).description)
            }

            Button {
                memoBoardViewModel.move(memo, destination: memoBoardViewModel.getSecondDestination(from: memo.category))
            } label: {
                Text(memoBoardViewModel.getSecondDestination(from: memo.category).description)
            }
        }
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView(memoListViewModel: MemoListViewModel(memos: DummyMemo.memos))
            .environmentObject(MemoBoardViewModel(memos: DummyMemo.memos))
    }
}
