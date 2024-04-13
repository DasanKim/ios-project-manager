# 🗂️ 프로젝트 매니저 _ 🌳🐿️

- 프로젝트 팀원: [Dasan🌳](https://github.com/DasanKim), [Mary🐿️](https://github.com/MaryJo-github)
- 프로젝트 리뷰어: [Green🍏](https://github.com/GREENOVER)

---

## 📖 목차
- 🍀 [소개](#소개) </br>
- 💻 [실행 화면](#실행_화면) </br>
- 🛠️ [핵심 경험](#핵심_경험) </br>
- 🧨 [트러블 슈팅](#트러블_슈팅) </br>
- 📚 [참고 링크](#참고_링크) </br>
- 👩‍👧‍👧 [about TEAM](#about_TEAM) </br>

</br>

## 🍀 소개<a id="소개"></a>
프로젝트의 할일들을 Todo, Doing, Done 3가지 상태로 관리할 수 있는 iPad용 앱입니다.

</br>

## 💻 실행 화면<a id="실행_화면"></a>


| 새 할 일 작성 | 메모 확인 |
| :--------: | :--------: |
| <img src="https://github.com/MaryJo-github/ios-project-manager/assets/42026766/281d6a52-d189-4b2f-b08d-d47d8c729328" width="400"> | <img src="https://github.com/MaryJo-github/ios-project-manager/assets/42026766/74b20bae-dd28-435a-a924-6c341357a0fc" width="400"> |

| 저장된 메모 수정 | 저장된 메모 삭제 |
| :--------: | :--------: |
| <img src="https://github.com/MaryJo-github/ios-project-manager/assets/42026766/77607581-53fa-40cf-9a9a-1d419bbe67f5" width="400"> | <img src="https://github.com/MaryJo-github/ios-project-manager/assets/42026766/58971d19-9713-4e4a-9931-68e12cedff97" width="400"> |


| 카테고리 변경 | Localization |
| :--------: | :--------: |
| <img src="https://github.com/MaryJo-github/ios-project-manager/assets/42026766/29b86b41-2e73-453b-99c7-992203bbbd9e" width="400"> | <img src="https://github.com/MaryJo-github/ios-project-manager/assets/42026766/8b47bd63-9f0c-40f4-bac3-e08ae6f459b4" width="400"> |


</br>

## 🛠️ 핵심 경험<a id="핵심_경험"></a>
- [StateObject와 ObservedObject](https://github.com/MaryJo-github/ios-project-manager/wiki/StateObject%EC%99%80-ObservedObject)
- [SwiftUI를 통한 UI 구현](https://github.com/MaryJo-github/ios-project-manager/wiki/SwiftUI%EB%A5%BC-%ED%86%B5%ED%95%9C-UI-%EA%B5%AC%ED%98%84)
    - 리스트에서 스와이프를 통한 삭제 구현
    - Date Picker를 통한 날짜 입력
    - 날짜 Localization
    - Custom Modify 적용
    - ZStack과 Overlay
    - Popover와 ContextMenu
- [MVVM 구조 채택](https://github.com/MaryJo-github/ios-project-manager/wiki/MVVM-%EA%B5%AC%EC%A1%B0-%EC%B1%84%ED%83%9D)

</br>

## 🧨 트러블 슈팅<a id="트러블_슈팅"></a>

### 1️⃣ 맨 마지막 Row의 메모만 보여지는 오류
🚨 **문제점** <br>
- List의 Row를 선택하면 해당 sheet가 보여져야 했습니다.
- 사용자의 tapGesture에 반응하기위하여 State 속성의 `isDisplaySheet` 프로퍼티를 만들고, 해당 값이 `true`일 때 sheet를 띄우도록 하였습니다.
- 하지만 실행해보니, 선택한 Row가 아닌 맨 마지막 Row의 메모만 보여졌습니다.
  
  <img src="https://github.com/yagom-academy/ios-project-manager/assets/106504779/4d1616fb-34aa-4514-bbf1-1e551969d1ad" width="500">

<details>
    <summary> 상세 코드 </summary>
    
```swift
// MemoListView.swift
...
@State private var isDisplaySheet: Bool = false

var body: some View {
    List {
        Section {
            ForEach(memos) { memo in
                VStack {
                    MemoCellView()
                    ...
                }
                .onTapGesture {
                    isPresented.toggle()
                }
                .sheet(isPresented: $isDisplaySheet) {
                    SheetView(memo: memo)
                }
            }
        }
    }
}
```
    
</details>

<br>

💡 **해결방법** <br>
- 해당 오류는 tapGesture가 인식되었을 때 showDetail이 true로 변경되면서 선택한 메모 뿐만 아니라 모든 메모의 Sheet가 활성화되면서 나타난 문제점으로 파악하였습니다.
- 저희는 두 가지 해결방법을 찾았습니다.
    1. currentMemo 프로퍼티를 생성하여 tapGesture가 인식되었을 때 선택한 Row의 메모를 담고, 해당 메모를 띄우는 방법
        <details>
            <summary> 상세 코드 </summary>

        ```swift
        // MemoListView.swift
        ...
        @State private var currentMemo: Memo? = nil

        var body: some View {
            List {
                Section {
                    ForEach(memos) { memo in
                        VStack {
                            MemoCellView()
                            ...
                        }
                        .onTapGesture {
                            currentMemo = memo
                        }
                        .sheet(item: $currentMemo) {
                            SheetView(memo: memo)
                        }
                    }
                }
            }
        }
        ```
        </details>
    2. MemoListView가 아닌 MemoCellView에서 State 속성의 `isDisplaySheet` 프로퍼티를 만들고, 해당 값이 `true`일 때 sheet를 띄우는 방법
        <details>
            <summary> 상세 코드 </summary>

        ```swift
        // MemoCellView
        ...
        @State var isDisplaySheet: Bool = false

        fileprivate var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                ...
            }
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
            ...
        }
        ```
        </details>
- 두 가지 해결방법 중 ForEach 내에서 sheet사용하기보다 가장 하위 계층에 있는 MemoCellView에서 sheet를 사용하는 것이 안전할 뿐만아니라, 역할적으로도 MemoCell에서 담당하는 것이 자연스럽다고 판단하여 두 번째 방법을 선택하여 진행하였습니다.
  
  <img src="https://github.com/yagom-academy/ios-project-manager/assets/106504779/4733ef6a-c6c1-4894-a35b-53d20a313221" width="500">

<br>

### 2️⃣ List Row의 터치영역
🚨 **문제점** <br>
- List의 Row를 터치하여 detail view를 띄울 때, Content(text) 부분에서만 터치 이벤트가 인식되고 그 외의 빈공간에서는 인식되지 않았습니다.

    <img src="https://github.com/yagom-academy/ios-project-manager/assets/106504779/d9487254-393d-4acf-bcf6-d582dd3aafef" width="500">

💡 **해결방법** <br>
- .contentShape(Rectangle())을 추가해줌으로써 전체 스택을 터치할 수 있도록 수정하였습니다.
    - `contentShape`는 hit testing용 content 모양을 정의합니다.
    - hit testing이란 터치나 드래그 같은 이벤트를 받는 것을 말합니다.
    
    <img src="https://github.com/yagom-academy/ios-project-manager/assets/106504779/075f9dc2-3a98-45fd-accf-6357f4a100b4" width="500">

<br>

### 3️⃣ 뷰 합치기
🚨 **문제점** <br>
- 새로운 Sheet View인 `NewMemo`View와 Row를 선택했을 때 띄워지는 `MemoDetail`View는 형태가 비슷하여 중복 코드가 많았습니다.

<table>
<tr>
<td> NewMemo </td> <td> MemoDetail </td>
</tr>
<tr>
<td>
    
```swift
struct NewMemo: View {
    @EnvironmentObject private var modelData: ModelData
    @State private var memo: Memo = Memo.newMemo
        
    var body: some View {
        NavigationView {
            VStack {
                TitleTextField(content: $memo.title)
                DeadlinePicker(date: $memo.deadline)
                BodyTextField(content: $memo.body)
            }
            .sheetBackground()
            .navigationTitle(memo.category.description)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button {
                        
                    } label: {
                        Text("Cancel")
                    },
                trailing:
                    Button {
                        
                    } label: {
                        Text("Done")
                    }
            )
        }
        .navigationViewStyle(.stack)
    }
}
```
    
</td>
<td>

```swift
struct MemoDetail: View {
@EnvironmentObject private var modelData: ModelData
private let memo: Memo
...

var body: some View {
    NavigationView {
        VStack {
            TitleTextField(content: $modelData.memos[memoIndex].title)
            DeadlinePicker(date: $modelData.memos[memoIndex].deadline)
            BodyTextField(content: $modelData.memos[memoIndex].body)
        }
        .sheetBackground()
        .navigationTitle(memo.category.description)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading:
                Button {

                } label: {
                    Text("Edit")
                },
            trailing:
                Button {

                } label: {
                    Text("Done")
                }
        )
    }
    .navigationViewStyle(.stack)
}
```

</td>
</tr>

</table>

💡 **해결방법** <br>
- 이에 해당 뷰들을 SheetView라는 뷰 하나로 통합하여 **코드 재사용성을 높여보고자** 하였습니다.
- View마다 달랐던 전달인자
    - 각 View가 가지고 있던 memo 프로퍼티를 ViewModel로 이동, View 마다 달랐던 (@Published) memo 프로퍼티 초기화 방식을 ViewModel의 init으로 주입받는 형식으로 통일해주었습니다.  
    - 또한 각 View 마다 달랐던 TextField 및 DatePicker의 전달인자를 ViewModel의 `@Published memo`로 통일해주었습니다.
    ```swift
    final class SheetViewModel: ObservableObject {
        @Published var isEditMode: Bool
        @Published var memo: Memo

        init(isEditMode: Bool = true,
             memo: Memo = .init(title: "", body: "", deadline: .now, category: .toDo)
        ) {
            self.isEditMode = isEditMode
            self.memo = memo
        }

        func navigationLeftBtnTapped() {
            isEditMode.toggle()
        }
    }
    ```
- View마다 달랐던 Button
    - 각 View에 따라 nagigationBar의 Button 모양이 달랐는데, 이는 ViewModel의 `@Published isEditMode` 프로퍼티를 통하여 View의 `상태`에 따라 Button 모양을 변경하도록 수정해주었습니다.
    ```swift
    // SheetView.swift
    ...
    private var leftButton: some View {
        Button(
            action: {
                if sheetViewModel.isEditMode { dismiss() }
                sheetViewModel.navigationLeftBtnTapped()
            },
            label: {
                Text(sheetViewModel.isEditMode ? "Cancel" : "Edit")
            }
        )
    }
    ... 
    ```

<br>

### 4️⃣ 하위 뷰에서 메모 수정 및 뷰 업데이트
🚨 **문제점** <br>
- MemoListView는 Category 별 ListView를 그리는 뷰입니다. 따라서 MemoBoardView에서 MemoListView를 그릴 때 전체 메모에서 `Category 별로 분류한 데이터`를 MemoListViewModel에 넘겨주고 있습니다.
    ```swift
    // MemoBoardView.swit
    struct MemoBoardView: View {
        @EnvironmentObject private var memoBoardViewModel: MemoBoardViewModel

        var body: some View {
            HStack(spacing: 4) {
                ForEach(memoBoardViewModel.categories, id: \.description) { category in
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
    ```    
    ```swift
    // MemoListView.swit
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
    ``` 
- 하지만 MemoListView 또는 그 하위 뷰에서 메모의 삭제나 category 이동이 일어났을 때, MemoBoardViewModel의 memos에 반영이 되었지만 변경된 카테고리가 보이는 화면에 반영되지 않는 문제점이 발생하였습니다.

  <img src="https://github.com/MaryJo-github/ios-project-manager/assets/42026766/130ce4f3-3b9b-4540-a0b3-d7f58ee1687f" width="500">

💡 **해결방법** <br>
- 해당 오류는 @StateObject로 정의한 memoListViewModel이 한 번만 초기화되기 때문에 발생하는 문제점으로 파악하였습니다. 
    - [@StateObject는 선언하는 컨테이너의 Lifetime동안 새 인스턴스를 한 번만 생성합니다.](https://developer.apple.com/documentation/swiftui/stateobject#overview)
    - 즉, MemoBoardViewModel의 memos가 변경됨에 따라 memoListViewModel의 인스턴스를 새로 만들어서MemoListView를 그리는 줄 알았으나, memoListViewModel은 초기에 한 번만 생성되고 변경되지 않은 것이었습니다.

- 저희는 두 가지의 해결방법을 찾았습니다.
    1. memoListViewModel을 @ObservedObject로 변경
        @ObservedObject는 매 번 새로운 인스턴스를 만들기 때문에 memos가 변경됨에 따라 뷰도 같이 업데이트됩니다.
        ```swift
        // MemoListView.swit
        struct MemoListView: View {
            @ObservedObject var memoListViewModel: MemoListViewModel

            var body: some View {
                ...
            }
        }
        ```
        
    2. [onChange(of:initial:\_:)](https://developer.apple.com/documentation/swiftui/view/onchange(of:initial:_:)-8wgw9) 메서드 활용
        메모의 변경이 일어나는 MemoListView의 하위 뷰에서 onChange 메서드를 통해 memoBoardViewModel의 memos의 변경사항을 감지하여, memoListViewModel의 memos를 category에 따라 다시 분류한 memos로 업데이트하였습니다.
        ```swift
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
                .onChange(of: memoBoardViewModel.memos) { memos in
                    memoListViewModel.memos = memos.filter { $0.category == memoListViewModel.category }
                }
            }
        }
        ```
- 두 가지 해결방법 중 @ObservedObject로 변경하는 방법은 뷰가 렌더링 될 때 마다 인스턴스를 새로 생성하므로 비효율적이라 판단하여 두 번째 방법을 선택하였습니다.

<br>


## 📚 참고 링크<a id="참고_링크"></a>
- [🍎Apple: swiftUI 튜토리얼](https://developer.apple.com/tutorials/swiftui)
- [🍎Apple Docs: StateObject](https://developer.apple.com/documentation/swiftui/stateobject)
- [🍎Apple Docs: ObservedObject](https://developer.apple.com/documentation/swiftui/observedobject)
- [🍎Apple Docs: swipeActions(edge:allowsFullSwipe:content:)](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:))
- [🍎Apple Docs: DatePicker](https://developer.apple.com/documentation/swiftui/datepicker)
- [🍎Apple Docs: ViewModifier](https://developer.apple.com/documentation/swiftui/viewmodifier)
- [🍎Apple Docs: ZStack](https://developer.apple.com/documentation/swiftui/zstack)
- [🍎Apple Docs: overlay(alignment:content:)
](https://developer.apple.com/documentation/swiftui/view/overlay(alignment:content:))
- [🍎Apple HIG: Popovers](https://developer.apple.com/design/human-interface-guidelines/popovers)
- [🍎Apple HIG: Context menus
](https://developer.apple.com/design/human-interface-guidelines/context-menus)
- [🍏WWDC: Data Flow Through SwiftUI](https://developer.apple.com/videos/play/wwdc2019/226/)
- [🌐blog: Localization 정리 & 선택된 App Language 알아내기](https://jooeungen.tistory.com/entry/iOSSwift-Localization-%EC%A0%95%EB%A6%AC-%EC%84%A0%ED%83%9D%EB%90%9C-App-Language-%EC%95%8C%EC%95%84%EB%82%B4%EA%B8%B0)

<br>

---

## 👩‍👧‍👧 about TEAM<a id="about_TEAM"></a>

| <Img src = "https://user-images.githubusercontent.com/106504779/253477235-ca103b42-8938-447f-9381-29d0bcf55cac.jpeg" width="100"> | 🌳Dasan🌳  | https://github.com/DasanKim |
| :--------: | :--------: | :--------: |
| <Img src = "https://hackmd.io/_uploads/r1rHg7JC3.jpg" width="100"> | **🐿️Mary🐿️** | **https://github.com/MaryJo-github** |

</br>
