//
//  Memo.swift
//  ProjectManager
//
//  Created by Mary & Dasan on 2023/09/22.
//

import Foundation

struct Memo: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var body: String
    var deadline: Date
    var category: Category
}
