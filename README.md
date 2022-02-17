# 동기화 메모장 📝


## 목차
- [STEP1: 메모 리스트 및 내용 화면의 UI 구현](#STEP1:-메모-리스트-및-내용-화면의-UI-구현)
    + [키워드](#1-1-키워드)
    + [구현 내용](#1-2-구현-내용)
    + [고민한 점](#1-3-고민한-점)


## 프로젝트 소개
(프로젝트 완료 후 영상 추가 예정)

## STEP1: 메모 리스트 및 내용 화면의 UI 구현

### 1-1 키워드
- iPad, UISplitViewController
- Dependency Injection
- ARC, Weak References
- Delegate Pattern
- JSON, Decoding
- DarkMode
- DateFormatter
- ContentOffset/ContentInset
- Dynamic type
- keyboardWillShowNotification
- Swift Lint, Cocoa Pod
---
### 1-2 구현 내용
- iPad 전용 메모 앱을 구현했습니다.
- SplitView의 MasterView는 TableViewController, DetailView는 ViewController를 통해 구현하여 각각 메모의 목록 및 내용을 나타냈습니다. 이때 JSON 파일의 샘플 데이터를 통해 메모를 표시했습니다.

#### 코드 구조
- Model
    - Memo 구조체 : JSON 데이터 parsing을 위해 맵핑할 Model 타입
- View
    - MasterTableViewCell 클래스 : Cell의 View 및 Layout과 관련된 기능을 구현, DateFormatter를 통해 지역화 구현
- Controller
    - MainSplitViewController 클래스 : `SplitView`를 커스텀함
    - MasterTableViewController 클래스 : `SplitView`의 MasterView. delegate를 가짐
    - DetailViewController 클래스 : `SplitView`의 DetailView. delegate 프로토콜을 채택
- 기타
    - SceneDelegate : Interface Buider 없이 코드로 UI를 구현하기 위해 스토리보드 삭제, MainSplitViewController 인스턴스 생성
---
### 1-3 고민한 점
#### 1. delegate 패턴
SplitView의 ChildView인 MasterTableViewController 및 DetailViewController 간의 의존성을 낮추기 위해 delegate 패턴을 사용했습니다. MasterView가 MemoSelectionDelegate 프로토콜 타입의 delegate를 가지고, DetailView가 MemoSelectionDelegate 프로토콜을 채택하도록 했습니다.

#### 2. 의존성 주입

MasterTableViewController의 delegate를 DetailViewController로 지정하기 위한 방법을 고민했습니다. 

Master/Detail View가 SplitView에 담겨있어 서로를 모르는 상황이므로 각 View에서 프로퍼티 주입을 하는 것보다는 아래 코드처럼 MainSplitViewController에서 생성자 주입을 하는 것이 낫다고 판단했습니다.
```swift
private func configureUI() {
    //...
    detailViewController = DetailViewController()
    masterViewController = MasterTableViewController(style: .plain, delegate: detailViewController) // 생성자 주입

    self.viewControllers = [
        UINavigationController(rootViewController: masterViewController),
        UINavigationController(rootViewController: detailViewController)
    ]
}
```

#### 3. Cell Reuse 할 때 guard else문 처리방법
`dequeueReusableCell` 메서드를 사용할 때 cell을 custom Cell 클래스로 타입 캐스팅을 진행해주는데, 이 부분에서 옵셔널 바인딩을 항상 진행해왔었습니다.

위 과정에서 고민했던 점은 해당 함수의 경우 Cell을 리턴하는데, guard else 처리시 그냥 빈 셀을 리턴해주는 것이 좋을지, 아니면 fatalError를 내보내는 것이 좋을지가 고민되었습니다.

`fatalError`로 설정하여 앱을 강제종료하는 것보단 차라리 빈 셀을 내보내는 것이 훨씬 안전하고 UX도 좋을 것 같아 빈셀을 리턴해주는 방식을 택하였습니다. 

```swift=
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            // fatalError("Failed to dequeue cell.")  // 위험해보임
            return T()
        }

        return cell
    }
}
```

#### 4. parsing한 데이터를 Detail View에 전달하는 방법

JSON 파일을 파싱한 데이터를 tableView에서도 사용을 하고, tableView의 특정 셀을 눌렀을 때 나오는 DetailView에서도 사용을 해야하는데, 파싱을 한번만 하여 나온 데이터를 두 곳 모두에서 사용해주려면 어떤 방법을 사용해야 가장 효율적일지 고민했습니다. 고려한 방법은 아래와 같습니다.

방법-1. SplitView의 `showDetailViewController` 메서드 활용
방법-2. ViewController의 `showDetailViewController` 메서드 활용
방법-3. ViewController Factory를 생성하여 열거형의 연관값을 활용

처음 생각한 방법은 Factory을 생성하는 것이었는데, 이는 DetailViewController를 생성하는 Factory이기 때문에 특정 셀이 클릭될 때마다 뷰컨트롤러가 새로이 생성되는 큰 문제점이 있을 것 같아 진행하지 않았습니다.

그래서 결과적으로 방법-1의 `showDetailViewController` 메서드를 활용하여 하나의 뷰컨트롤러의 인스턴스를 미리 생성한 뒤 뷰에 올려진 텍스트뷰의 텍스트를 업데이트 해주는 방법으로 구현하였습니다.

