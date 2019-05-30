# FlickerDigitalAlbum

Flickr 공개 피드의 이미지를 하나씩 보여주는 전자앨범

# 빌드 방법

Flicker의 공개 피드 이미지를 계속 보여주는 앨범 프로젝트

CocoaPods 을 이용하여 SwiftLint를 설치해야 프로젝트를 빌드 할 수 있다.
다음의 순서대로 SwiftLint를 설치하고 프로젝트 빌드를 진행해야 한다.

1. 프로젝트 최상위 위치에서 콘솔 창을 띄운 후 'pod install' 명령어를 실행하여 SwiftLint를 설치한다.
2. 설치 후 'FlickerDigitalAlbum.xcworkspace' 파일을 이용하여 프로젝트를 실행한다.
3. 이후 빌드를 진행하면 정상적으로 실행이 된다.

# 사용법

사진 슬라이드 화면에서 화면을 탭 하면 위쪽 내비게이션을 숨기거나 보이게 할 수 있다.

# 기본 구현 요구 사항

아래 Flickr API 를 이용한다. (format 은 자유롭게 변경 할 수 있다.)
https://api.flickr.com/services/feeds/photos_public.gne?tags=landscape,portrait&tagmode=any

1. 피드의 목록에 있는 이미지를 모두 보여준 경우 새로운 피드 목록의 이미지를 보여줘야 한다. 다음 피드 목록의 이미지를 보여줄때 딜레이(목록 요청 시간 등)가 없어야 한다.
2. 이미지 전환 효과는 fade-in, fade-out 을 구현하고 전환 효과 시간은 이미지가 보여지는 시간에서 제외한다.
3. 인터넷 연결이 끊기면 유저에게 알려 준다.
4. Swift 4.2 or above 로 작성한다.
5. Deployment taget >= iOS 10.0
6. Portrait/Landscape 지원해야 한다.
7. 아이패드에서도 동작하는 유니버설 앱이어야 한다.
8. iPhone Notch 지원해야 한다.
9. Cocoapods, Carthage 사용 할 수 있다.
10. Autolayout 사용해야 한다.
11. README.md 에 빌드 방법이 포함되어야 한다.
12. SwiftLint 를 사용한다. 설정은 이 .swiftlint.yml 파일을 이용 한다.

# 사용자 스토리

1. 앱을 실행하면 시작 화면이 보인다.
2. 시작 화면에서 이미지 하나가 보이는 시간(1초~10초)을 설정할 수 있다.
3. 시작 화면에서 "시작" 버튼을 누르면 슬라이드쇼 시작할 수 있다.
4. 슬라이드쇼 화면에서도 이미지 하나가 보이는 시간(1초~10초)을 변경할 수 있다.
5. 슬라이드쇼 중 시작 화면으로 돌아갈 수 있다.
6. 모든 화면에서 디바이스를 회전하면 현재 화면이 회전한다.
7. 앱에서 인터넷 연결 끊김 여부를 유저가 확인할 수 있다.
