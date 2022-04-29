# AniHouse
숭실대학교 2022-2 전공종합설계 iOS앱

## 프로젝트 세팅
* Xcode 13
* RealmSwift 10.24.1
* Swift 5.2
* SF Symbol V3

## Podfile
.gitignore 파일에 커밋 시 용량이 큰 라이브러리가 함게 커밋되는 것을 막기 위해 Pods 폴더안에 있는 파일은 커밋되지 않도록 함.<br>
Firbase에서 다운로드 받은 **GoogleService-Info.plist** 파일 안의 ID는 공개해선 안되므로 .gitignore 파일에 추가함. 파일은 따로 공유

```
# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'AniHouse-iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AniHouse-iOS
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'RealmSwift', '~>10'
  
  # 필요없는 경고 제거
  inhibit_all_warnings!
  
  # iOS deployment 경고 제거
  post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
      end
    end

end
```

```
pod init
```

```
pod install --repo-update
```
---
## 🔨로그인 화면
Lottie Animation을 사용해서 로그인화면에 애니메이션 삽입<br>
백그라운드 컬러는 **assets.xcassets** 에 Custom Color그룹을 만들고 Light Gray색상을 등록
id 입력부분은 입력한 텍스트 부분이 보이지만, 비밀번호는 입력한 텍스트가 보이지 않도록 함.<br>
<img src="https://user-images.githubusercontent.com/76734067/160101113-b122b821-686d-4287-a1e4-a7683c78b8d8.gif" width="36%">

---
## 🔨회원가입 화면
Form 구조체를 사용해서 폼을 설계하였다.<br>
네비게이션 바의 아이템으로 키보드를 내릴 수 있는 아이템과 회원가입버튼을 지정해주었다.<br>
회원가입 버튼을 누르면 `@Published` 애노테이션으로 지정된 `isSigned` 변수의 값이 `true`로 변경되며 홈 뷰로 이동한다.
또한 `FirebaseAuth`와의 연결을 통해서 회원이 직접등록되는 것 까지 확인하였다.
<img src="https://user-images.githubusercontent.com/76734067/160276091-e99a57a6-8651-4972-a1c2-aba8d8683961.png" width="70%"><br>
LoginView도 로그인 버튼을 눌렀을 때 `FirebaseAuth`에서 회원을 조회하고, 만약 등록되지 않은 회원일 때에는
알림을 내보내도록 개발하였다.<br>
<p>
<img src="https://user-images.githubusercontent.com/76734067/160276287-42cfe4a4-18c9-4ff5-bc68-32d6e75aeea7.gif" width="28%">
<img src="https://user-images.githubusercontent.com/76734067/160276327-e0becdb6-f34c-46df-8e6f-4ba28a9e40d1.gif" width="28%">
<img src="https://user-images.githubusercontent.com/76734067/160276387-fe4cb757-33d8-42bc-8f8e-67a3e095f1ef.gif" width="28%">
</p>

---
## 🔨메인 뷰
`LazyVGrid`를 통해서 구현하였습니다.

<img width="124" alt="image" src="https://user-images.githubusercontent.com/76734067/165814994-bdd7c2ba-518c-4626-ada3-431c80e1c222.png">
<br>

### 2022-04-29 기준

각 그리드는 위와 같은 셀들로 구성되어 있으며, 전체적인 화면은 한줄에 2개의 열로 구성되어 있습니다. 
위의 기본 셀은 어떤 이미지도, 제목도, 내용도 없는`ScrollView` 를 통해서사용자가 아래로 스크롤 할 수 있으며, 위 의셀은 임시로
그리드 뷰를 보여주기 위해서 기본이미지와 타이틀을 적용한 상태입니다. 

화면 우측하단의 버튼을 눌러서 글을 작성할 수 있는 화면으로 넘어가도록 하였습니다. 

게시글의 구성요소는 다음과 같으며, 아래의 정보들이 FireStore에 저장됩니다.
* 게시글 작성자
* 제목
* 내용
* 이미지

게시글 작성화면에서 하단의 이미지 버튼을 누르면, 이미지를 선택할 수 있는 화면으로 넘어갑니다.

자유게시판이 이미지 없이 작성할 수 있는 화면인 반면, 메인에서는 이미지 없이는 작성할 수 없도록 할 예정입니다.
<p>
<img src="https://user-images.githubusercontent.com/76734067/165816985-74d841e5-35be-4646-8529-5e04ccdae4df.gif" width="30%">
<img src="https://user-images.githubusercontent.com/76734067/165818548-6a02c25f-28b1-4e80-a298-c730f66d64a1.gif" width="30%" >
</p>
화면 우측 하단의 버튼을 누르면 글을 작성할 수 있는 화면으로 넘어간다.
