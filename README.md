# 📝 동기화 메모장

1. 프로젝트 기간: 2022.02.07 - 2022.02.25
2. Ground Rules
    1. 시간
        - 시작시간 10시
        - 점심시간 12시~2시
        - 저녁시간 6시~8시
    - 진행 계획
        - 프로젝트가 중심이 아닌 학습과 이유에 초점을 맞추기
        - 의문점을 그냥 넘어가지 않기
    - 스크럼
        - 10시에 스크럼 시작
3. 커밋 규칙
    1. 단위
        - 기능 단위
    - 메세지
        - 카르마 스타일
        
## 🗂 목차

- [⌨️ 키워드](#-키워드)
- [STEP 1 : 리스트 및 메모영역 화면 UI구현](#STEP-1--리스트-및-메모영역-화면-UI구현)
    + [고민했던 것](#1-1-고민했던-것)
    + [의문점](#1-2-의문점)
    + [Trouble Shooting](#1-3-Trouble-Shooting)
    + [배운 개념](#1-4-배운-개념)
    + [PR 후 개선사항](#1-5-PR-후-개선사항)

## ⌨️ 키워드

- `UISplitViewController`
- `DateFormatter` `Locale` `TimeZone`
- `UITapGestureRecognizer`
- `subscript` `Collection`
- `SceneDelegate`
- `NavigationItem` `UIBarButtonItem`
- `UITextViewDelegate`


# STEP 1 : 리스트 및 메모영역 화면 UI구현

리스트 화면과 메모영역 화면을 SplitViewController를 활용하여 구현합니다.

## 1-1 고민했던 것

### 1. 키보드 가림현상 개선 및 편집모드 종료 구현
* NotificationCenter를 활용하여 키보드가 화면에 표시될 때 UITextView도 키보드의 높이만큼 contentInset을 조정하도록 구현하였다.
* 편집을 끝낸 후 다른 메모를 눌렀을 때 편집모드를 종료할 수 있도록 구현했다. UITapGestureRecognizer를 활용하여 사용자가 텍스트뷰가 아닌 다른 부분을 터치했을 때 endEditing 메소드를 호출하도록 하였다.

### 2. 실시간으로 수정된 메모가 UITableView에 반영되도록 구성
* 실시간 반영을 위해 UITextViewDelegate를 활용하여 UITextView가 수정될 때 마다 데이터를 수정하고, UITableView도 업데이트하도록 기능을 구현하였다.

### 3. Crash를 방지
* 존재하지않는 인덱스를 조회했을 때 Crash가 나지 않도록 subscript를 활용하여 Crash가 발생하지 않도록 구현하였다.

```swift
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
```

### 4. Dynamic Type
* UILabel, UITextView에 실시간으로 글씨 크기를 조정할 수 있도록 다이나믹 폰트 설정 및 Automatically Adjusts Font 기능을 활성화 해주었다.

### 5. 메모를 터치했을 때 secondary 뷰컨에 상세 메모를 표시하도록 구현
* MemoListViewController의 UITableViewDelegate 메서드 didSelectRowAt에서 SplitViewController의 present메서드를 통해 눌린 테이블뷰 셀의 indexPath를 활용하였다.
* indexPath로 SplitViewController가 가지고있는 Memo 배열 타입의 데이터 중에서 해당되는 데이터를 골라서 MemoDetailViewController의 text view를 업데이트한다. 

## 1-2 의문점

* `translatesAutoresizingMaskIntoConstraints`는 왜 `false`로 지정해주는 걸까?
* 특정 행에 해당되는 셀을 업데이트 할 수 있는 방법이 있을까?
* `GestureRecognizer`를 등록했을 때 `UITableViewDelagate`가 왜 먹통이지?
* 실행 시 primaryVC이 보여졌으면 좋겠는데...
* SplitViewController의 secondaryVC은 왜 배경색이 회색이지?
* 데이터를 primary와 secondary에 효율적으로 뿌려줄 순 없을까?

## 1-3 Trouble Shooting

### 1. Cell의 Select가 먹히는 문제

* `상황` GestureRecognizer를 ViewController에 추가하자 UITableView의 Select가 되지 않는 현상이 나타났다.
* ![](https://i.imgur.com/4Vf9LkM.gif)
* `이유` 등록한 GestureRecognizer의 프로퍼티인 cancelsTouchesInView가 기본값으로 true로 설정되어있어 문제였다. `cancelsTouchesInVie`w가 `true`인 경우에는 제스처를 인식한 후에 나머지 터치정보들을 뷰로 전달하지 않고 취소되었기 때문에 UITableView의 Select가 먹지 않았던 것이다.
* `해결` 따라서 cancelsTouchesInView값을 `false`로 할당해줌으로써 해당 문제를 해결하였다. 제스처를 인식한 후에도 Gesture Recognizer의 패턴과는 무관하게 터치 정보들을 뷰에 전달할 수 있게 되었다.

### 2. 메모장에 텍스트가 없는 경우 Crash나는 문제

* `상황` 메모장에 linebreak가 1개일 때 Crash가 나는 현상이 나타났다. 아래는 모든 메모를 지웠을 경우 Crash가 나는 상황이다.
* ![](https://i.imgur.com/FcRbJJu.gif)
* `이유` 배열을 조회할 때 존재하지 않는 인덱스를 조회할 경우 앱이 죽어버리는 상황이였던 것이다.
* `해결` 따라서 인덱스를 안전하게 조회하도록 subscript를 extension 해주어 조회가 불가능한 상황에 맞게 대처할 수 있도록 해결하였다.
    ```swift
    extension Collection {
        subscript (safe index: Index) -> Element? {
            return indices.contains(index) ? self[index] : nil
        }
    }
    ```

## 1-4 배운 개념

<details>
<summary>Split View에서 인터페이스가 축소되었을때 먼저 보여지는 뷰를 secondary가 아니라 primary로 설정하기</summary>
<div markdown="1">

### Split View에서 인터페이스가 축소되었을때 먼저 보여지는 뷰를 secondary가 아니라 primary로 설정하기

* 아이패드에서 스플릿뷰로 다른 앱과 화면을 같이 쓰는 경우 화면이 작아져서 primary와 secondary뷰가 한번에 보이지 않았다. primary뷰인 메모목록이 먼저 보여지게 하고 싶었는데 secondary뷰인 메모장이 먼저 보여지는 현상이 발생하였다.
* 디폴트 값이 secondary뷰임을 확인하고 primary가 먼저 보여지도록 delegate 메서드를 통해 설정해주었다.
```swift
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
```



</div>
</details>

<details>
<summary>DateFormatter 지역화</summary>
<div markdown="1">

### DateFormatter 지역화
* TimeInterval 타입으로 주어진 메모 작성날짜를 날짜 형식으로 변경하기위해 TimeInterval 타입을 extension하여 연산 프로퍼티를 구현하였다.
* 사용자의 지역에 맞는 날짜를 보여주기 위해 DateFormatter의 locale를 활용하였다. 
```swift
extension TimeInterval {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let localeID = Locale.preferredLanguages.first
        let deviceLocale = Locale(identifier: localeID ?? "ko-kr").languageCode
        dateFormatter.locale = Locale(identifier: deviceLocale ?? "ko-kr")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
```


</div>
</details>

<details>
<summary>코드로 뷰 구현하기: SceneDelegate 에서 initial View Controller 설정</summary>
<div markdown="1">

### 코드로 뷰 구현하기: SceneDelegate 에서 initial View Controller 설정
* 스토리보드를 지운 후 SceneDelegate의 scene메서드에서 window의 rootViewController를 앱의 첫화면에 보이는 splitVC로 설정한다.
* 그리고 makeKeyAndVisible()로 화면에 보이도록 설정하여 Storyboard에서 initial view controller로 지정하는 것을 대신해줄 수 있다.
```swift
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windoewScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windoewScene)
        let splitVC = SplitViewController(style: .doubleColumn)
        window?.rootViewController = splitVC
        window?.makeKeyAndVisible()
    }
```


</div>
</details>

<details>
<summary>BarButtonItem 활용</summary>
<div markdown="1">

    
### BarButtonItem 활용
* UIViewController에 있는 `navigationItem` 프로퍼티를 사용하여 title과 BarButtonItem 등 navigation에 필요한 item을 설정할 수 있다.
* `UIBarButtonItem`의 이니셜라이저에는 image를 파라미터로 받거나, barButtonSystemItem을 파라미터로 받을 수 있어 필요한 것을 골라서 사용할 수 있다.
```swift
navigationItem.title = "메모"
navigationItem.rightBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .add, 
    target: self, 
    action: nil
)
navigationItem.rightBarButtonItem = UIBarButtonItem(
    image: UIImage(systemName: "ellipsis.circle"),
    style: .plain,
    target: self,
    action: nil
)
```


</div>
</details>

<details>
<summary>UISplitViewController</summary>
<div markdown="1">

### UISplitViewController
* `setViewController(_:for:)` : UISplitViewController의 메서드로 Double Column 스타일인 경우에 primary와 secondary 뷰컨트롤러를 지정한다. 
* 이 메서드로 지정하는 경우에 자동으로 뷰컨트롤러에 네비게이션 컨트롤러를 감싸서
UISplitViewController에 할당해준다. 

```swift
class SplitViewController: UISplitViewController {
    private let primaryVC = MemoListViewController(style: .insetGrouped)
    private let secondaryVC = MemoDetailViewController()
    
    private func setUpChildView() {
        setViewController(primaryVC, for: .primary)
        setViewController(secondaryVC, for: .secondary)
    }
}
```


</div>
</details>

<details>
<summary>UITableView reloadRows 를 활용해 수정된 row만 업데이트하기</summary>
<div markdown="1">

### UITableView reloadRows 를 활용해 수정된 row만 업데이트하기
tableView.reloadData로 테이블뷰의 모든 데이터를 업데이트한다면 너무 비효율적이라고 생각하여 수정된 부분만 업데이트하도록 구현하였다.

![](https://i.imgur.com/Wy8nMTM.gif)
    
1. MemoListViewController에서 MemoDetailViewController로 화면전환될때 터치된 테이블뷰셀의 indexPath를 전달하여 프로퍼티로 저장한다. 
2. indexPath를 SplitViewController로 전달하여 SplitViewController가 프로퍼티로 가지고있는 primaryVC의 updateData 메서드를 실행한다.
3. MemoListViewController에서 전달받은 indexPath로 해당되는 셀의 데이터만 업데이트한다.

```swift
extension MemoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        splitVC.present(at: indexPath.row)
    }
}
```

```swift
class SplitViewController: UISplitViewController {

    func present(at indexPath: Int) {
        let title = memoList[indexPath].title
        let body = memoList[indexPath].body
        secondaryVC.updateTextView(with: MemoDetailInfo(title: title, body: body))
        secondaryVC.updateIndex(with: indexPath)
        show(.secondary)
    }
}
```

```swift
extension MemoDetailViewController: UITextViewDelegate {
    private var currentIndex: Int = 0
    func textViewDidChange(_ textView: UITextView) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        let memo = createMemoData(with: textView.text)
        splitVC.updateMemoList(at: currentIndex, with: memo)
    }
}
```

```swift
class SplitViewController: UISplitViewController {
    func updateMemoList(at index: Int, with data: Memo) {
        memoList[index] = data
        let title = data.title.prefix(Constans.maximumTitleLength).description
        let body = data.body.prefix(Constans.maximumBodyLength).description
        let lastModified = data.lastModified.formattedDate
        let memoListInfo = MemoListInfo(title: title, body: body, lastModified: lastModified)
        primaryVC.updateData(at: index, with: memoListInfo)
    }
}
```

```swift
class MemoListViewController: UITableViewController {
    func updateData(at index: Int, with data: MemoListInfo) {
        memoListInfo[index] = data
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}
```


</div>
</details>


[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#동기화-메모장)
