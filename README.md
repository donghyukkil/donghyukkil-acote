# Donghyukkil Acote Assignment

## 프로젝트 설명
이 Flutter 프로젝트는 GitHub API를 활용하여 GitHub 사용자를 검색하고, 해당 사용자의 상세 정보를 제공하는 기능을 구현한 과제 프로젝트입니다. 주요 기능은 다음과 같습니다:
- GitHub 사용자 목록 가져오기
- 사용자 검색
- 페이지네이션을 통한 사용자 목록 갱신
- 사용자 상세 정보 보기 (리포지토리 목록 등)
- 광고 배너 추가
- Pull to Refresh

## 🎨 앱 화면 미리보기
|                                           HomeScreen                                           |                                       사용자 리포지토리 검색                                        |                                           사용자 검색                                           |
|:----------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------:|
| ![HomeScrren](https://github.com/user-attachments/assets/66556aaa-38a8-4c58-a2dd-605c073757ec) | ![DetailScreen](https://github.com/user-attachments/assets/98093b2a-aa3e-468f-9f75-3c9cd2b9e9d2) | ![사용자 검색](https://github.com/user-attachments/assets/7198f560-580f-49dc-b75a-bc9ae22f94f3) |

## 🚀 실행 방법

1. 프로젝트 클론

    ```bash
    git clone https://github.com/donghyukkil/donghyukkil-acote.git
     ```

2. 디렉토리로 이동

    ```bash
    cd donghyukkil-acote
     ```

3. **필요한 Flutter 종속성 설치**:
    
   ```bash
    flutter pub get
    ```

4. **앱 빌드 및 실행**:
    
   ```bash
    flutter run
    ```

## My Journey with State Management in Flutter.
이번 프로젝트는 좀 더 체계적이고 확실하게 상태 변화를 제어하고 싶은 생각이 들어서 Bloc을 도입하게 되었습니다.
본격적인 과제 진행에 앞서 일정 시간 Bloc만을 위한 학습 기간을 가졌고, 점차 Bloc에 익숙해지면서 Bloc의 장점을 경험할 수 있는 시간이 되었습니다.

### MVVM 과 Provider

기존 프로젝트에서는 Provider를 사용하면서 MVVM 아키텍처를 도입하였습니다. View에서 상태와 비즈니스 로직을 추출하여 ViewModel에 위치시켰고
필요한 데이터를 받아와 적절히 가공하여 새로운 상태로 만들고 나서 ChangeNotifier()를 호출하고 View가 필요한 정보를 구독하여 UI를 업데이트할 수 있다는 점이 신기했습니다.
View에 혼재되어 있던 비즈니스 로직과 상태를 추출하고 MVVM과 같이 각각의 파일에게 서로 다른 책임을 부여해 프로젝트를 설계해 나갈 수 있다는 점에 매료되었던 것 같았습니다.
그래서인지 다른 상태 관리 대안들을 모색한다기보다는, Provider에 DeepDive하고자 했습니다. 특히 Bloc은 다른 것에 비해 배우고 적용하기에 러닝커브가 있다고 알고 있었기 때문에 특별히 관심을 주지 않았습니다.

View를 단순하게 만들기 위해 비즈니스 로직과 상태를 ViewModel로 이동시켰습니다. 그 결과 ViewModel이 점차 방대해지는 결과를 낳게 되었습니다.
View는 코드양이 줄고 가독성이 향상되었지만, 오히려 ViewModel은 코드양이 많아지고 ViewModel의 메서드 여러 곳에서 상태를 업데이트하고 changeNotifer()를 호출했기 때문에, 상태 관리의 흐름을 따라가기가 어려웠습니다.
그래서 방대해진 ViewModel에서 코드를 추출하여 Repository를 도입하였고 또한 ViewModel에서 관리되던 개별 변수들을 객체로 그룹짓고 Freezed를 도입하여서 상태에 불변성을 도입하여 좀 더 ViewModel의 상태 관리에 질서를 부여하고자 노력했습니다.
하지만 여전히 체계 없이 그리고 개발자에 의해 자유로운 방식으로 또한 수동적인 방식으로 상태를 관리해야만 했습니다. 그렇기 때문에 Bloc을 도입하여서 어떠한 개발자라 하더라도, 일정한 패턴으로 체계적으로 상태를 용이하게 관리하기 위해 이번 프로젝트에 Bloc을 도입하였습니다.

Bloc은 MVVM에서 ViewModel에 대응한다고 할 수 있습니다. 하지만 Bloc은 ViewModel의 상태 관리 책임을  Bloc, event, state 파일로 더 세분화하여 분리하고
정해진 규칙에 의해서 상태를 제어하게끔 합니다. 그래서 Provider에 비해 상태 관리에 체계가 부여되고 다른 개발자에게 상태를 업데이트하는 방식 (혹은 패턴)을 강제할 수 있어서 왜 협업이 많은 프로젝트에서 Bloc을 도입하는지 그 이유에 대해 공감할 수 있었습니다.

### nextState = BLoC(event, previousState)

Bloc이 상태 관리에 체계와 강제성을 부여합니다. 그 방식을 비유하자면 Bloc은 argument로 event, 상태 값을 넣어서 새로운 상태를 리턴하는 거대한 함수라고 할 수 있습니다. BLoC 방식에서는 상태와 이벤트를 명확하게 분리합니다. 이벤트가 발생하면 BLoC이 그에 따라 상태를 계산하고 출력합니다.

	1.	이벤트 트리거: 사용자가 특정 액션을 수행하면 이벤트가 발생합니다. 예를 들어,GitHub 사용자 목록을 불러오고자 한다면 FetchGithubUsers 이벤트가 발생합니다.

	2.	상태 전이: 이벤트가 발생하면, GithubUsersBloc에서 그 이벤트에 맞는 상태 전이가 실행됩니다. 예를 들어, API 호출 전에는 GithubUserLoading 상태가 발생하고, 데이터를 성공적으로 가져오면 GithubUserLoaded 상태로 전이됩니다.

	3.	다음 상태 반환: 상태 전이가 완료되면 새로운 상태가 emit되어 UI에 반영됩니다.

상태를 중앙에서 관리하고(Bloc) 이벤트를 발생시켜서 상태를 업데이트하는 명확한 패턴을 준수하게끔 개발자들에게 강제할 수 있기 때문에, Provider와는 다르게 상태 관리고 일관적이고 체계적으로 느껴졌습니다. 
그래서 Bloc의 상태 업데이트 방식을 일종의 도식처럼 느껴졌고. 소제목에서와 같은 표현식으로 Bloc의 작동방식을 비유해보고자 했습니다.

# 기술스택

- Front-end:
   - Dart, Flutter, Github API, Bloc, Mockito

<br>

# 연락처

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/donghyukkil">
        <img src="https://avatars.githubusercontent.com/u/124029691?v=4" alt="길동혁 프로필" width="100px" height="100px" />
      </a>
    </td>
  </tr>
  <tr>
    <td>
      <ul>
        <li><a href="https://github.com/donghyukkil">길동혁</a></li>
		    <li>asterism90@gmail.com</li>
	    </ul>
    </td>
  </tr>
</table>

