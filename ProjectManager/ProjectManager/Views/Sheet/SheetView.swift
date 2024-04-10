//
//  SheetView.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/10/04.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var memoBoardViewModel: MemoBoardViewModel
    @StateObject var sheetViewModel: SheetViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                TitleTextField(content: $sheetViewModel.memo.title)
                DeadlinePicker(date: $sheetViewModel.memo.deadline)
                BodyTextField(content: $sheetViewModel.memo.body)
            }
            .sheetBackground()
            .disabled(!sheetViewModel.isEditMode)
            .navigationTitle(sheetViewModel.memo.category.description)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: leftButton,
                trailing: rightButton
            )
        }
        .navigationViewStyle(.stack)
    }
    
    private var leftButton: some View {
        Button(
            action: {
                if sheetViewModel.isEditMode {
                    dismiss()
                }
                sheetViewModel.navigationLeftBtnTapped()
            },
            label: {
                Text(sheetViewModel.isEditMode ? "Cancel" : "Edit")
            }
        )
    }
    
    private var rightButton: some View {
        Button("Done") {
            memoBoardViewModel.save(sheetViewModel.memo)
            dismiss()
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(sheetViewModel: SheetViewModel())
            .environmentObject(MemoBoardViewModel())
    }
}
