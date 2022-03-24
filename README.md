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
