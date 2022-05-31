//
//  AddFreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import SwiftUI
import Firebase

struct AddFreeBoardView: View {
    @State private var boardTitle = ""
    @State private var boardBody = ""
    @State private var showingAlert = false
    @State private var showingFailureAlert = false
    @State private var usingForbidWord = false
    
    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    @EnvironmentObject var storageManager: StorageManager
    
    @Environment(\.presentationMode) var presentationMode
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        VStack(alignment: .leading) {
            // 제목을 입력하는 부분
            TextField("제목을 입력하세요", text: $boardTitle)
                .font(.system(size: 20, weight: .heavy, design: .default))
                .padding(5)
                .cornerRadius(15)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            Divider()
            ZStack(alignment: .topLeading) {
                // 본문내용을 입력하는 부분
                TextEditor(text: $boardBody)
                    .font(.system(size: 16))
                    .frame(minWidth: nil, idealWidth: .infinity, maxWidth: nil, minHeight: 300, idealHeight: 400, maxHeight: 450)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                //                        .background(Color(Constant.CustomColor.lightBrown))
                
                if boardBody.isEmpty {
                    Text("내용을 입력하세요")
                        .font(.system(size: 16))
                        .foregroundColor(Color.secondary)
                        .padding(5)
                }
            }
            Spacer()
        }
        .background(Color(Constant.CustomColor.lightBrown).edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    // 제목 혹은 내용을 작성하지 않았을 경우
                    if boardTitle == "" || boardBody == "" {
                        showingFailureAlert = true
                    }
                    else if freeContainForbidWord() {
                        showingFailureAlert = true
                        usingForbidWord.toggle()
                    }
                    // 모두 작성한 경우
                    else {
                        showingFailureAlert = false
                        
                        // 시간에 따라 작성된 게시글 우선순위를 둠
                        // 파이어스토어에 저장하기
                        freeFirestoreViewModel.addData(title: boardTitle,
                                                       body: boardBody,
                                                       author: user?.email ?? "unknown",
                                                       hit: 0,
                                                       date: Date())
                        freeFirestoreViewModel.getData()
                        
                        boardTitle = ""
                        boardBody = ""
                        
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("저장")
                })

            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingFailureAlert) {
            if usingForbidWord {
                return Alert(title: Text("상처주는 표현이 포함되어 있지 않나요?"), message: Text("부적절한 표현이 감지됩니다. 반복 등록시 이용이 제한될 수 있습니다."), dismissButton: .destructive(Text("알겠습니다")))
            } else {
                 return Alert(title: Text("모든 항목을 작성해주세요"), message: nil, dismissButton: .default(Text("확인")))
            }
            
        }
    }
    func freeContainForbidWord() -> Bool {
        for word in Constant.forbidWord {
            if boardTitle.contains(word) || boardBody.contains(word) {
                return true
            }
        }
        return false
    }
}

struct AddFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        AddFreeBoardView()
    }
}
