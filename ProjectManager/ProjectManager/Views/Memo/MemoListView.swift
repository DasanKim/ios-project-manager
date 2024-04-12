//
//  MemoListView.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/09/22.
//

import SwiftUI

struct MemoListView: View {
    @StateObject var memoListViewModel: MemoListViewModel
    
    init(memoListViewModel: MemoListViewModel) {
        _memoListViewModel = StateObject(wrappedValue: memoListViewModel)
        print("메모 리스트 뷰")
    }
    
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
        print("타이틀 뷰")
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
        print("메모 리스트 컨텐츠 뷰")
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
        .onChange(of: memoBoardViewModel.memos) { memos in
            memoListViewModel.memos = memos.filter { $0.category == memoListViewModel.category }
        }
    }
}

// MARK: - 메모 셀 뷰
private struct MemoCellView: View {
    @ObservedObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var memoBoardViewModel: MemoBoardViewModel
    @State private var isDisplaySheet: Bool = false
    private var memo: Memo
    
    fileprivate init(
        memoListViewModel: MemoListViewModel,
        memo: Memo
    ) {
        self.memoListViewModel = memoListViewModel
        self.memo = memo
        print("메모 셀 뷰")
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HorizontalSpacing()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(memo.title.isEmpty ? "새로운 할 일" : memo.title)
                    .font(.title3)
                    .lineLimit(1)
                
                Text(memo.body.isEmpty ? "추가 텍스트 없음" : memo.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                Text(memo.deadline.formattedDate)
                    .foregroundColor(memoListViewModel.checkDeadlineExpired(memo: memo) ? .red : .primary)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
        }
        .listRowInsets(EdgeInsets())
        .contentShape(Rectangle())
        .onTapGesture {
            isDisplaySheet.toggle()
        }
        .sheet(isPresented: $isDisplaySheet) {
            SheetView(
                sheetViewModel: .init(
                    isEditMode: false,
                    memo: memo)
            )
        }
        .contextMenu {
            Button {
                memoBoardViewModel.move(memo, destination: memoListViewModel.firstDestination)
            } label: {
                Text("\(memoListViewModel.firstDestination.description)으로 이동")
            }

            Button {
                memoBoardViewModel.move(memo, destination: memoListViewModel.secondDestination)
            } label: {
                Text("\(memoListViewModel.secondDestination.description)으로 이동")
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
