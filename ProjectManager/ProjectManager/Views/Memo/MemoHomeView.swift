//
//  MemoHomeView.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/09/22.
//

import SwiftUI

struct MemoHomeView: View {
    @StateObject private var memoHomeViewModel = MemoHomeViewModel()
    @StateObject private var memoBoardViewModel = MemoBoardViewModel(memos: DummyMemo.memos)
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorSet.navigationBarBackground.edgesIgnoringSafeArea(.all)
                ColorSet.backgroundBetweenLists
                
                MemoBoardView()
                    .environmentObject(memoBoardViewModel)
                    .clipped()
                    .navigationBarTitle("Project Manager")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        trailing:
                            Button {
                                memoHomeViewModel.plusBtnTapped()
                            } label: {
                                Image(systemName: "plus")
                            }
                            .sheet(isPresented: $memoHomeViewModel.isDisplaySheet) {
                                SheetView(sheetViewModel: SheetViewModel())
                                    .environmentObject(memoBoardViewModel)
                            }
                    )
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct MemoHome_Previews: PreviewProvider {
    static var previews: some View {
        MemoHomeView()
    }
}
