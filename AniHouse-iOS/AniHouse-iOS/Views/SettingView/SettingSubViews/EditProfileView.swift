//
//  EditProfileView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/26.
//

import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    @EnvironmentObject var storageManager: StorageManager
    @Environment(\.presentationMode) var presentationMode


    @State private var profileImage: UIImage = UIImage(named: Constant.ImageName.defaultUserImage)!
    @State private var isShowingPhotoPicker: Bool = false
    @State private var showUpdateProfileAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color(Constant.CustomColor.normalBrown)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: storageManager.profileImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 230, height: 230)
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                self.isShowingPhotoPicker.toggle()
                            }
                    }
                    Text("\(self.userInfoManager.userNickName)")
                        .fontWeight(.black)
                        .font(.system(size: 30))
                        .padding(5)
                    
                    ZStack {
                        if storageManager.introduce.isEmpty {
                            Text("자기소개를 입력해주세요")
                                .foregroundColor(.secondary)
                        }
                        
                        TextEditor(text: $storageManager.introduce)
                            .background(Color(Constant.CustomColor.lightBrown))
                            .cornerRadius(5)
                            .frame(minWidth: nil, idealWidth: .infinity, maxWidth: nil,
                                   minHeight: 200, idealHeight: 350, maxHeight: 300)
                    }
                    
                    Button {
                        self.showUpdateProfileAlert.toggle()
                    } label: {
                        Text("저장하기")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color(Constant.CustomColor.strongBrown))
                            .cornerRadius(10)
                    }
                    .alert(isPresented: self.$showUpdateProfileAlert) {
                        Alert(title: Text("프로필 정보 변경"), message: Text("프로필 정보를 저장하시겠습니까?"),
                              primaryButton: .default(Text("예"), action: {
                            // 여기서 스토리지에 이미지를, 스토어에 자기소개 정보를 저장한다.
                            print("프로필 정보를 저장합니다.")
                            storageManager.uploadUserProfileImage(email: userInfoManager.user!.email!) // 프로필 이미지 저장
                            userInfoManager.setUserIntroduce(email: userInfoManager.user!.email!, introduce: self.storageManager.introduce)
                            presentationMode.wrappedValue.dismiss()
                        }),
                              secondaryButton: .destructive(Text("아니오")))
                    }

                    
                }
            }
            .padding(.horizontal, 5)
            .sheet(isPresented: $isShowingPhotoPicker, content: {
                //content
                PhotoPicker(bindedImage: $storageManager.profileImage)
            })
        } // ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
