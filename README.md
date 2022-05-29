<img src = "https://user-images.githubusercontent.com/76734067/170886150-2482745b-906f-4e69-a075-28844ce87c59.png">

> 우리 가족을 자랑하는 반려동물 커뮤니티 서비스 🐶

<br />

## 💭 About
> 반려동물을 처음 기를때 어려움이 있지 않았나요?
>
> 이제는 걱정하지 마세요 반려동물과 함께했던 경험이 있던분들이<br>
> 함께 해줄거에요


# AniHouse
숭실대학교 2022-2 전공종합설계 iOS앱

## 프로젝트 환경
<p>
<img src="https://img.shields.io/badge/iOS-15.2-black?logo=apple">
<img src="https://img.shields.io/badge/Xcode-13.2.1-blue?logo=xcode">
<img src="https://img.shields.io/badge/Swift-5.2-orange?logo=swift">
</p>

* RealmSwift 10.24.1
* SDWebImage 2.0.2
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
  pod 'lottie-ios'
  pod 'Firebase/Storage'
  
  pod 'SDWebImageSwiftUI'

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

## 2022-04-29 기준

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
<br><br>

## 2022-05-08
기본적으로 사용되던 MainView의 셀들을, 이미지, 타이틀, 본문의 실제데이터를 firestore에서 불러와 적용하였습니다.
firestore를 사용하기 위해서 새로운 viewModel을 개발하였고, 이 viewModel은 `ObservedObject` 구조체를 상속받으며,
firestore에 저장한 게시글을 내부에서`@Published`로 선언한 `posts`변수에 저장하도록 하였습니다.

firestore내부의 게시글 컬렉션이름은 `MainViewPost`이며, 도큐먼트 하나는 다음으로 이루어져 있습니다.
* `title`: 게시글의 제목
* `body`: 게시글의 내용
* `date`: 게시글이 작성된 날짜
* `hit`: Like 횟수
* `author`: 게시글 작성자
* **컬렉션 `comment`**
  - `author`: 댓글 작성자
  - `content`: 댓글 내용
  - `date`: 댓글 작성 날짜

게시글에 포함되어 있는 이미지는 firestore에 저장하기 번거롭다고 판단하여 Firebase Storage에 저장하였다.
이미지의 이름은 해당하는 게시글의 `document name`으로 하여 MainView에서 셀들을 로드하거나, 게시글을 눌러 게시글의 정보를 볼때
Storage에서 해당이미지만 불러올 수 있도록 프로그래밍 하였다.


### ⛔️ **error**
게시글을 작성한 후에 다시 `MainView`로 돌아오게되는데, 이때 Storage에 이미지가 업로드 되기 전에 View를 로드하여 이미지를 불러올 수
없었다. url정보를 확인해보니, View가 로드된 다음에 이미지를 불러온 것 같았다. 그리고 `MainView`자체에서 이미지를 불러오고 출력하고,
데이터를 갱신하는등 너무 많은 역할을 하나의 View에서 수행하는 듯 하여, 게시글의 정보를 담은 MainPost 객체를 MainViewCell에 넘겨주고,
각각의 cell에서 이미지, 제목, 내용 등을 불러오도록하였다.

MainViewCell의 View가 출력될 때(.onAppear) 게시글의 이미지 정보를 불러오고, `DispatchQueue.main.asycAfter`를 이용하여
1초 후에 다시 로드하도록 프로그램하여 해결하였다.

### 프로그램 동작
<p>
<img width="30%" src="https://user-images.githubusercontent.com/76734067/167267729-8b2a474c-06cc-4549-8f81-d677e9320d8d.gif">
<img width="30%%" src="https://user-images.githubusercontent.com/76734067/167267802-b458c029-38af-4f4d-b0e2-5a2068280487.gif">
<img width="30%" src="https://user-images.githubusercontent.com/76734067/167268096-687a5773-576e-4464-bc68-f6a3baddf126.gif">
</p>

