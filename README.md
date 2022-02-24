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

- [⌨️ 키워드](#-키워드)
- [STEP 1 : 리스트 및 메모영역 화면 UI구현](#STEP-1--리스트-및-메모영역-화면-UI구현)
    + [고민했던 것](#1-1-고민했던-것)
    + [의문점](#1-2-의문점)
    + [Trouble Shooting](#1-3-Trouble-Shooting)
    + [배운 개념](#1-4-배운-개념)
    + [PR 후 개선사항](#1-5-PR-후-개선사항)
- [STEP 2 : 코어데이터 DB 구현](#STEP-2--코어데이터-DB-구현)
    + [고민했던 것](#2-1-고민했던-것)
    + [의문점](#2-2-의문점)
    + [Trouble Shooting](#2-3-Trouble-Shooting)
    + [배운 개념](#2-4-배운-개념)
    + [PR 후 개선사항](#2-5-PR-후-개선사항)
- [STEP 3 : 클라우드 연동](#STEP-3--클라우드-연동)
    + [고민했던 것](#3-1-고민했던-것)
    + [의문점](#3-2-의문점)
    + [Trouble Shooting](#3-3-Trouble-Shooting)
    + [배운 개념](#3-4-배운-개념)
    + [PR 후 개선사항](#3-5-PR-후-개선사항)
- [STEP 4 : 추가 기능 및 UI 구현](#STEP-3--추가-기능-및-UI-구현)
    + [고민했던 것](#4-1-고민했던-것)
    + [의문점](#4-2-의문점)
    + [Trouble Shooting](#4-3-Trouble-Shooting)
    + [배운 개념](#4-4-배운-개념)

## ⌨️ 키워드

- `UISplitViewController`
- `DateFormatter` `Locale` `TimeZone`
- `UITapGestureRecognizer`
- `subscript` `Collection`
- `SceneDelegate`
- `NavigationItem` `UIBarButtonItem`
- `UITextView`
    - `typingAttributes`
    - `UITextViewDelegate`
- `Core Data` `NSPersistentCloudKitContainer` `NSEntityDescription`
    - `NSFetchRequest` `NSPredicate` `NSSortDescriptor`
    - `NSManagedObject` 
- `NSMutableAttributedString`
- `UIActivityViewController` `UIAlertController`
    - `popoverPresentationController`
- `UITableView`
    - `UISwipeActionsConfiguration` `UIContextualAction`
    - `insertRows` `selectRow` `deleteRows`
    - `UITableViewCell`
        - `setSelected` `selectedBackgroundView`
- `viewWillTransition`
- `UIFont`
    - `UIFontMetrics` `UIFontDescriptor`
- `flatMap`
- `Swift Package Manager`
- `SwifryDropbox`
    - `DispatchGroup`
    - `FileManager`
- `UIActivityIndicatorView`
- `UISearchController`
- `Localization`
    - `NSLocalizedString`
- `Accessibility` `Dynamic Type` `VoiceOver`
    - `Accessibility Inspector`
- `Lite Mode` `Dark Mode`


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

## 1-5 PR 후 개선사항

* View의 보여줄 요소들을 별도의 타입으로 만들어 보여주었던 부분을 제거후 Core Data로 모두 통일하여 리팩토링

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#동기화-메모장)

# STEP 2 : 코어데이터 DB 구현

메모를 위한 코어데이터 모델을 생성합니다.

## 2-1 고민했던 것

### 1. 사용자 친화적인 UI를 구현

* 최근에 작성, 수정하였던 메모가 상단으로 올라올 수 있도록 메모 리스트의 정렬을 날짜를 기준으로 내림차순으로 정렬
* 어떤 메모를 선택해서 작성하고 있는지 한눈에 보기 편하도록 작성하고 있는 Cell을 계속 Select 되도록 구현
* 작성하는 도중 날짜가 업데이트 되면, 상단으로 이동하면서 Select도 상단으로 이동.
* 메모를 추가했을 때 추가한 새로운 메모를 Select 되도록 구현
* 메모를 삭제했을 때, 삭제한 부분 이후 메모를 자동으로 Select 되도록 구현
* 스와이프 및 더보기 버튼 터치시 보여지는 액션버튼이 단순 텍스트가 아닌 아이콘이 표기되도록 구현
* Share를 터치하여 UIActivityViewController가 present 되었을 때 화면 회전 시에도 컨트롤러가 중앙에 계속 위치할 수 있도록 구현

### 2. 코어데이터를 관리하는 매니저 타입 구현

* 메모의 CRUD를 구현 및 View에 보여줄 데이터를 관리할 수 있는 `PersistentManager` 구현
* fetch를 할 때 `Predicate`, `Sort` 등을 유연하게 할 수 있도록 파라미터 별도 구현

### 3. 제목과 본문의 폰트를 다르게 하여 구분하는 기능 구현
* `AttributtedString`을 사용하여 TextView의 제목과 본문의 폰트를 다르게 하여 사용자가 보기에 편하도록 구현
* textView의 delegate 메서드(`shouldChangeTextIn`)와 textView의 `typingAttributes` 프로퍼티를 사용하여 입력중에도 제목과 본문에 맞는 폰트가 적용되도록 구현


## 2-2 의문점

* Core Data - codegen을 어떻게 설정해야 적절할까?
* NSFetchRequest - returnsObjectsAsFaults 속성값은 어떤 역할을 하는 것일까?
* NSFetchRequestResult 프로토콜이 뭘까?
* 본문의 제목을 굵게 표시하면서 다이나믹 타입을 적용할 수 있을까?
* UIContextualAction의 handler의 completeHandeler는 어떤 역할을 하는 것일까?
* UIAlertController - ActionSheet를 iPad에서 present 하려면 어떻게 해야하지?


## 2-3 Trouble Shooting

### 1. iPad에서 UIAlertController의 actionSheet 사용시 발생하는 오류

> 오류메세지

* UIActivityViewController를 present를 해주려는데 아래와 같은 오류메세지가 떴다.
```
Thread 1: "Your application has presented a UIAlertController (<UIAlertController: 0x10d813a00>) of style UIAlertControllerStyleActionSheet from CloudNotes.SplitViewController (<CloudNotes.SplitViewController: 0x11f7068f0>).
The modalPresentationStyle of a UIAlertController with this style is UIModalPresentationPopover. 
You must provide location information for this popover through the alert controller's popoverPresentationController.
You must provide either a sourceView and sourceRect or a barButtonItem. 
If this information is not known when you present the alert controller, you may provide it in the UIPopoverPresentationControllerDelegate method -prepareForPopoverPresentation."
```
* 간단히 해석하자면 iPad에서 액션시트를 present를 할 경우 모달스타일이 UIModalPresentationPopover이고, 이걸 사용할 때는 barButtonItem 또는 해당 창의 대한 위치를 설정해주어야 한다고 되어있다.
* 따라서 설정해주어야 하는 것은 2가지중 하나이다.
    * 필수적으로 sourceView 지정해주기
    * [popoverPresentationController](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621428-popoverpresentationcontroller)에 sourceRect 또는 barButtonItem 할당해주기

> 해결 방법

얼럿을 present 해주기 전에 다음과 같은 if문을 추가해주자!

* UIBarButtonItem에 추가해주는 방법
```swift
// UIViewController extension 내부...
if let popoverController = activityViewController.popoverPresentationController {
    popoverController.sourceView = self.splitViewController?.view
    popoverController.barButtonItem = sender // 메소드 내부라서 파라미터로 barButtonItem 전달받아 할당해주었다.
}
```
* 위치를 정해주는 방법
```swift
if let popoverController = activityViewController.popoverPresentationController {
    popoverController.sourceView = self.splitViewController?.view // present할 뷰 지정
    popoverController.sourceRect = CGRect( // 뷰의 정 가운데 위치로 지정
        x: self.splitViewController?.view.bounds.midX,
        y: self.splitViewController?.view.bounds.midY,
        width: 0,
        height: 0
    )
    popoverController.permittedArrowDirections = [] // 화살표를 빈배열로 대입
}
```
> ### 의문점
> 위치를 지정하고 나서 화면을 돌렸는데... 가운데 위치에 안있고 요상한 곳에 있다....
> ![](https://i.imgur.com/9Dk3gSK.gif)

* 해결방법
* 화면이 돌아갈 때마다 포지션을 다시 잡아주면 된다. 그걸 위해 [viewWillTransition](https://developer.apple.com/documentation/uikit/uicontentcontainer/1621466-viewwilltransition) 메소드를 활용해보겠다.
    * 이 메소드는 ViewController의 뷰 크기를 변경하기 전에 호출이 된다.
* 일단 얼럿을 present하는 뷰에 popoverController라는 변수를 만들어준다.
```swift
class SplitViewController: UISplitViewController {
    ...
    var popoverController: UIPopoverPresentationController?
```
* 그리고 viewWillTransition 메소드를 오버라이드하여 위치를 고쳐주는 로직을 추가한다.
```swift
if let popoverController = self.popoverController {
    popoverController.sourceRect = CGRect(
    x: size.width * 0.5,
    y: size.height * 0.5,
    width: 0,
    height: 0)
}
```
* UIViewController extension으로 만들어준 메소드 내부(맨 처음 얼럿을 생성하여 present하는 곳)에도 popoverController를 할당해주도록 해주었다.
```swift
let splitViewController = self.splitViewController as? SplitViewController
splitViewController?.popoverController = popoverController
```
> ### 해결된 모습
> ![](https://i.imgur.com/uy2XqZj.gif)

### 2. UITableView Cell을 selectRow를 호출했을 때 발생한 Crash

> UITableView의 selectRow를 통해 Select를 시도했을 때, 아래와 같은 에러가 나면서 Crash가 발생했다.
```
Thread 1: 
"Attempted to scroll the table view to an out-of-bounds row (0) when there are only 0 rows in section 0. 
Table view: <UITableView: 0x13f031400; 
frame = (0 0; 420 834); 
clipsToBounds = YES; 
autoresize = W+H; gestureRecognizers = <NSArray: 0x600000031680>;
layer = <CALayer: 0x600000ec7b80>; contentOffset: {0, -74}; 
contentSize: {420, 72.5}; adjustedContentInset: {74, 0, 20, 0}; 
dataSource: <CloudNotes.MemoListViewController: 0x14880fad0>>"
```
* `상황` 메모장의 마지막 남은 셀을 지우게 되면서 selectRow가 호출이 되는 상황이였다.
* `이유` **셀을 지우고 난 후**니까 UITableView에 보여줄 데이터가 존재하지 않고, Cell도 존재하지 않는 상황이였는데, `존재하지 않는 셀`을 `Select`를 하려고 해서 크래쉬가 난 것이였다.
* `해결` 따라서 Select를 하기 전에 먼저 UITableView에 `numberOfRows(inSection:)` 메소드를 통해 해당 값이 0이 아닐 경우에만 seletRow를 호출할 수 있도록 guard문을 추가하여 해결해주었다.

```swift
func updateData(at index: Int) {
    guard self.tableView.numberOfRows(inSection: .zero) != .zero else {
        return
    }
    ...
    tableView.selectRow(at: IndexPath(row: .zero, section: .zero), animated: false, scrollPosition: .middle)
}
```

### 3. UITableView의 Cell을 deleteRows로 지웠을 때 발생한 Crash

> JSON 모델에서 Core Data로 리팩토링 과정에서 난 에러였다.
```
Thread 1: 
"Invalid update: invalid number of rows in section 0. 
The number of rows contained in an existing section after the update (15) must be equal to the number of rows contained in that section before the update (15), plus or minus the number of rows inserted or deleted from that section (0 inserted, 1 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).
 Table view: 
<UITableView: 0x11081d400;
 frame = (0 0; 420 1194); 
clipsToBounds = YES; 
autoresize = W+H; 
gestureRecognizers = <NSArray: 0x6000033708a0>; layer = <CALayer: 0x600003d8cb40>; 
contentOffset: {0, -74}; 
contentSize: {420, 1160}; 
adjustedContentInset: {74, 0, 20, 0};
 dataSource: <CloudNotes.NotesViewController: 0x12a808ee0>>"
```
- `상황` 테이블 뷰의 섹션의 행 개수와 실제 보여줄 섹션 개수가 맞지 않아서 발생하는 오류이다.
- `이유` 테이블뷰의 셀을 삭제하면서 테이블뷰에 보여줄 데이터도 동일하게 삭제처리를 해주어야 하는데, 누락되서 발생한 것이였다.
- `해결` 셀을 추가, 삭제할 때 테이블뷰에 보여줄 섹션의 개수도 동일할 수 있도록 PersistentManager의 notes 관리(배열 요소 제거, 코어데이터 요소 제거)도 빼먹지 않도록 해주었다.

## 2-4 배운 개념

<details>
<summary>tableView의 Delegate 메서드를 활용한 스와이프 기능 활용 </summary>
<div markdown="1">

## [tableView의 Delegate 메서드를 활용한 스와이프 기능 활용]
    
tableView의 Delegate 메서드를 활용하여 셀을 스와이프 했을 때 선택할 수 있는 옵션을 설정 할 수 있다.
    
```swift
// 오른쪽에서 왼쪽으로 스와이프 했을 때의 옵션 설정
override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        // ...
    }
    
// 왼쪽에서 오른쪽으로 스와이프 했을 때의 옵션 설정
override func tableView(_ tableView: UITableView, 
    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        // ...
    }
```

</div>
</details>

<details>
<summary>Core Data - Codegen</summary>
<div markdown="1">

## [Codegen]

https://developer.apple.com/documentation/coredata/modeling_data/generating_code

> 프로젝트 하는 도중에 codegen을 어떤 옵션으로 줘야할지 감이 안와서 찾아보았다.

* 해당 entity에 대한 클래스 선언을 자동으로 만들어 주는 옵션을 설정합니다.
    * None/Manual: 관련 파일을 자동으로 만들어주지 않는다. 개발자는 DataModel을 선택한 상태에서 Editor-Create NSManagedObject Subclass 항목을 클릭하여 클래스 선언 파일과 프로퍼티 extension 파일을 빌드시마다 추가시켜 주고, 이를 수동으로 관리해야 한다.
    * Class Definition: 클래스 선언 파일과 프로퍼티 관련 extension 파일을 빌드시마다 자동으로 추가시켜준다. 따라서 관련된 파일을 전혀 추가시켜줄 필요가 없다.(그래서도 안된다. 만약 수동으로 추가시켜준 상태에서 빌드를 시도하면 컴파일 에러가 발생한다.)
    * Category/Extension: 프로퍼티 관련 extension파일만 자동으로 추가시켜 준다. 즉, 클래스 선언에는 사용자가 원하는 로직을 자유롭게 추가할 수 있다.



</div>
</details>

<details>
<summary>NSFetchRequest - returnsObjectsAsFaults</summary>
<div markdown="1">

## [NSFetchRequest - returnsObjectsAsFaults]

https://developer.apple.com/documentation/coredata/nsfetchrequest/1506756-returnsobjectsasfaults

* CoreData을 관리하는 모델을 설계하다가 이런 프로퍼티를 발견하게 되었다.
* 기본값은 true인 속성이다.
* true인 경우 Request로 가져온 객체가 Faulting인 경우라고 한다.
    * https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/FaultingandUniquing.html

>Faulting 예시
![](https://i.imgur.com/ZbWKJo1.png)
* 사진과 같이 Department는 클래스 인스턴스이다. 그리고 인스턴스가 생성되어있지만, 속성은 비어있는 상태이다. 이 상태를 `결함이 있다`라고 본다는 것이다. (이를 오류라고 함) 부서가 존재하지 않으니 직원 인스턴스도 생성할 필요가 없을 뿐만 아니라 관계도 채울필요도 없음을 의미한다.
* 그래프가 완전 해야 하는 경우 직원의 프로퍼티를 편집하려면 궁극적으로 전체 기업 구조를 나타내는 개체를 만들어야한다.

> 따라서 returnsObjectsAsFaults가 true인 경우 위와 같은 결함을 가지고있는 경우에도 위 그림과 같은 Department 인스턴스를 생성하지않는다는 이야기인 것 같다. 즉 결함을 허용하겠다는 의미인걸까? false인 경우에는 결함이 있던 말던 모든 인스턴스를 반환하도록 강제한다는 뜻인 것 같다.

* 뭔 말인지 잘 이해가 가지 않아서 좀더 공부가 필요할 것 같다...
* 중요한 것은 returnsObjectsAsFaults 이 플래그가 CoreData에 매우 메모리 효율적인 Lazy loading를 수행하도록 지시한다고 한다. [?]
    * `메모리 최적화`랑 연관이 있다고...
    * https://ali-akhtar.medium.com/mastering-in-coredata-part-10-nsfetchrequest-a011684dd8f7


</div>
</details>

<details>
<summary>NSFetchRequestResult</summary>
<div markdown="1">

## [Protocol - NSFetchRequestResult]

https://developer.apple.com/documentation/coredata/nsfetchrequestresult

* FetchRequest를 보낼때 단순히 NSManagedObject말고 다른 타입들도 유연하게 받고싶다면, 이 프로토콜을 활용할 수 있다.
* Conforming Types
    * NSDictionary
    * NSManagedObject
    * NSManagedObjectID
    * NSNumber


</div>
</details>

<details>
<summary>UIContextualAction에 텍스트말고 아이콘 삽입하는 방법</summary>
<div markdown="1">


## [UIContextualAction에 텍스트말고 아이콘 삽입하는 방법]

```swift
let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completeHandeler in
    self.deleteCell(indexPath: indexPath)
    completeHandeler(true)
}
deleteAction.image = UIImage(systemName: "trash.fill")
```
* 먼저 [UIContextualAction](https://developer.apple.com/documentation/uikit/uicontextualaction) 인스턴스를 생성한다.
* 생성할 때 title이 nil인게 포인트이다.
* 이후 생성한 UIContextualAction에 image를 대입해주면 된다.

> 적용된 모습

![](https://i.imgur.com/SdZTntY.png)

> `의문점`
> UIContextualAction 파라미터 중 handler의 용도는 무엇일까?
https://developer.apple.com/documentation/uikit/uicontextualaction/handler

* handler의 작업이 실제로 수행된 경우 핸들러에 true를 전달하여 작업이 완료되었다는 것을 알려주는 용도라고 한다.
* 지금같이 간단한 로직인 경우 그냥 true로 기입해주면 되겠지만, 만약 복잡한 로직이 추가되어 에러처리를 해줘야하는 경우에는 false를 전달하여 작업이 완료되지 않았다는 것을 알리는 용도인 것 같다.
* https://developer.apple.com/forums/thread/129420
* 여기 글을 참고하니 현재는 completeHandeler를 사용하지 않지만, 나중에 사용할 수 있으므로 적절한 값을 전달하는 것을 권장한다는 답변이 있다.
* 그래서 팀원들과 의논하여 true로 기입해주기로 하였다.


</div>
</details>

<details>
<summary>UIAlertAction 편집하기(titleTextAlignment, image)</summary>
<div markdown="1">

## [UIAlertAction 편집하기]

> 단순한 글자말고 여기에도 아이콘같은걸 추가할 수 있을까? 
```swift
let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
let deleteImage = UIImage(systemName: "trash.fill")
deleteAction.setValue(deleteImage, forKey: "image")
deleteAction.setValue(0, forKey: "titleTextAlignment")
```
* setValue 메소드를 통해서 지정해줄 수 있었다.
* 단순하게 이미지와 텍스트의 alignment를 지정해주었다.
    * 0 - left
    * 1 - center
    * 2 - right

> 적용된 모습

![](https://i.imgur.com/ke4Oujp.png)


</div>
</details>

## 2-5 PR 후 개선사항

* flatMap을 활용하여 옵셔널 바인딩 부분을 간결하게 개선
* primary, secondary 서로의 이벤트 전달을 SplitViewController가 아니라  Delegate 패턴으로 개선
* 가독성이 떨어지는 메소드를 메소드로 분리하여 개선
* 셀을 선택하고 스와이프 했을 때 선택이 해제되는 버그 개선
* 더보기 버튼에서 메모를 삭제한 후 다음 메모장을 보여주도록 개선

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#동기화-메모장)


# STEP 3 : 클라우드 연동

SwiftyDropbox 라이브러리를 활용하여 메모장과 클라우드 연동을 합니다.

## 3-1 고민했던 것

### 1. 업로드 시점

* 업로드 하는 시점을 정할 때 고려한 것은 너무 빈번하게 업로드를 하지 않아야 하며, 앱이 의도치 않게 종료되어도 어느정도 방어가 되어야 한다는 점이었다. 
* 처음에는 텍스트뷰에 변화가 일어날 때마다 하려고 하였으나 너무 빈번하게 일어날 것으로 보였다. 그래서 종료할 때 하려고 하니 의도치 않은 종료에 전혀 방어가 되지 않았다. 
* 여러 고민을 한 결과 키보드를 내릴 때 마다 업로드를 하도록 하여 업로드가 빈번하게 일어나지 않도록 하였고 의도치 않게 종료되어도 방어를 할 수 있도록 하였다.

### 2. 다운로드의 시점

* 다운로드 시점은 처음에 사용자가 로그인을 성공하는 시점에 dropbox의 데이터를 다운로드 하여 보여주는 주도록 구현하길 원했다. 그래서 인증이 완료 되고 authResult(인증결과)가 success가 되면 download를 하도록 하였다. 
* 또한, 다운로드는 비동기로 진행이 되기 떄문에 DispatchGroup을 사용하여 다운로드가 완료되면 앱에 데이터를 뿌려주고 테이블뷰를 업데이트 하도록 구현하였다.

### 3. 다운로드가 진행중일 때 뷰의 상태

* 다운로드가 진행될 동안 뷰는 아무것도 보여주지 않게 된다. 
* 로딩중이라는 것을 사용자에게 알려주기 위해서 ActivityIndicator를 사용하였다.
* 다운로드를 요청하고 ActivityIndicator를 사용자에게 보여주도록 하고 다운로드가 모두 완료되면 ActivityIndicator는 종료되며 데이터를 사용자에게 보여주도록 구현하였다.


## 3-2 의문점

* ScopeRequest의 scopes는 뭘까?
* CoreData의 경로는 어디일까?
* CoreData를 덮어쓰기가 아니라 원하는 데이터만 업데이트 해줄 수는 없을까?
* `wal`, `shm이` 무슨뜻일까?

## 3-3 Trouble Shooting

* ### 1. download가 끝나는 시점에 뷰를 업데이트 하기

> 다운로드가 끝난 후 CoreData를 fetch를 하고 TableView를 reload를 해주고 싶었으나 실패했었다.

* `이유` 파일이 여러개가 존재하여, 여러개의 파일을 다운로드 하기 위해 반복문을 돌리고 있었으나, fetch와 reload를 for-in문 내부에서 해주고 있어서, 뷰가 업데이트 될 때가 있고, 안되기도 하는 현상이 나타났다.
</br>
* `해결` 그래서 `for-in문이 종료된 시점`에 `fetch`를 하고 view를 reload를 해주기 위해, 다운로드가 모두 완료되는 시점을 `DispatchGroup`를 활용하여 `추적`하고, 반복문에서 시작되었던 다운로드 작업이 모두 끝나게 되면 아래 뷰를 다시 설정하도록 코드를 수정하였다.

```swift
func download(_ tableViewController: NotesViewController?) {
    let group = DispatchGroup() // 그룹 생성
    for fileName in fileNames {
        let destURL = applicationSupportDirectoryURL.appendingPathComponent(fileName)
        let destination: (URL, HTTPURLResponse) -> URL = { _, _ in
            return destURL
        }
        group.enter() // 작업 시작
        client?.files.download(path: fileName, overwrite: true, destination: destination)
            .response { _, error in
                if let error = error {
                    print(error)
                }
                group.leave() // 작업 끝
            }
    }
    group.notify(queue: .main) { // 모든 작업이 끝난다면 ...
        PersistentManager.shared.setUpNotes()
        tableViewController?.tableView.reloadData()
        tableViewController?.stopActivityIndicator()
    }
}
```

## 3-4 배운 개념

<details>
<summary>[Swift Package Manager를 사용하여 라이브러리 활용하기]</summary>
<div markdown="1">


> `Targets` -> `General` -> `Frameworks, Libraries, and Embedded Content` -> `+`

![](https://i.imgur.com/MxRxY4R.png)

> `Add Package Dependency...` 를 클릭

![](https://i.imgur.com/3iPfMsZ.png)

> 사용하고 싶은 라이브러리의 주소를 기입한다.

![](https://i.imgur.com/YGUZll3.png)

> 설치 시 원하는 버전, 브랜치 및 커밋을 설정할 수 있다. 이 후 원하는 packge product를 골라서 Finish 까지 하면...

![](https://i.imgur.com/ejnhQOL.png)

> `SwiftyDropbox`가 정상적으로 설치된 것을 확인할 수 있다.

</div>
</details>

<details>
<summary>[프로젝트에 SwiftyDropbox 설정하기]</summary>
<div markdown="1">

> 아래 프로젝트 설정하는 튜토리얼을 참고하여 진행하였다.

https://github.com/dropbox/SwiftyDropbox#configure-your-project

> 먼저 Info.plist 파일을 수정해주어야 하는데, 그 전에 dropbox에 app을 등록해야 한다. 로그인 후 apps에 들어가면 아래와 같은 버튼이 있다.

![](https://i.imgur.com/xBg2zZc.png)

> 이후 필수 문항을 선택, 입력 후 create app 버튼을 눌러 만들어주면 된다.

![](https://i.imgur.com/mqSylZ5.png)

> 그러면 App key가 발급되는데, 이걸 이제 Info.plist를 수정하는데 활용할 것이다.

![](https://i.imgur.com/QuHdJk5.png)

튜토리얼에서 하라는데로 Info.plist를 예시와 같이 수정해준다.

```
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>dbapi-8-emm</string>
        <string>dbapi-2</string>
    </array>
```

> 아까 만들고 얻은 App key를 `db-` 뒤부터 기입해주면 된다.

```
<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>db-<APP_KEY></string>
            </array>
            <key>CFBundleURLName</key>
            <string></string>
        </dict>
    </array>
```

![](https://i.imgur.com/ltONNs1.png)

> 이후 코드로 돌아가서 AppDelegate에 DropboxClient 인스턴스를 초기화 해준다.

```swift
import SwiftyDropbox

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    DropboxClientsManager.setupWithAppKey("<APP_KEY>")
    return true
}
```

> 그리고 SceneDelegate에 아래와 같은 메소드를 추가한다.

```swift
import SwiftyDropbox

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
     let oauthCompletion: DropboxOAuthCompletion = {
      if let authResult = $0 {
          switch authResult {
          case .success:
              print("Success! User is logged into DropboxClientsManager.")
          case .cancel:
              print("Authorization flow was manually canceled by user!")
          case .error(_, let description):
              print("Error: \(String(describing: description))")
          }
      }
    }

    for context in URLContexts {
        // stop iterating after the first handle-able url
        if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
    }
}
    }
```

> 이후 맨처음에 시작하는 뷰에 로그인을 해서 인증 토큰을 받아오는 작업을 추가한다. 이번 프로젝트 같은 경우 UISplitViewController를 사용했는데, rootView인 SplitViewController에서는 해당 작업이 정상적으로 뜨지않았다. (이유는 찾지 못했다.) 그래서 다른 UIViewController에서 진행해야하나.. 싶어서 UITableViewController의 viewDidLoad()에서 해당 작업을 실행해주니 로그인창이 정상적으로 떴다.

```swift
import SwiftyDropbox

func myButtonInControllerPressed() {
    // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
    let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
    DropboxClientsManager.authorizeFromControllerV2(
        UIApplication.shared,
        controller: self,
        loadingStatusDelegate: nil,
        openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
        scopeRequest: scopeRequest
    )

    // Note: this is the DEPRECATED authorization flow that grants a long-lived token.
    // If you are still using this, please update your app to use the `authorizeFromControllerV2` call instead.
    // See https://dropbox.tech/developers/migrating-app-permissions-and-access-tokens
    DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                  controller: self,
                                                  openURL: { (url: URL) -> Void in
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                  })
}
```

> 여기서 scopes라는 파라미터가 있는데, 이 부분은 앱이 Dropbox 계정 정보를 보고 관리할 수 있도록 권한의 범위를 뜻한다. 아까 App key를 얻었던 곳에서 Permissions 탭을 클릭하면 Account의 정보가 나온다. 따라서 필요한 Account를 scopes에 넣어주면 되겠다.

![](https://i.imgur.com/1O8bJws.jpg)

> 이 다음에 API에 호출할 DropboxClient 인스턴스를 생성한다.

```swift
import SwiftyDropbox

// Reference after programmatic auth flow
let client = DropboxClientsManager.authorizedClient
```

> client를 통해 업로드와 다운로드를 진행할 수 있다.

```swift
let fileData = "testing data example".data(using: String.Encoding.utf8, allowLossyConversion: false)!

let request = client.files.upload(path: "/test/path/in/Dropbox/account", input: fileData)
    .response { response, error in
        if let response = response {
            print(response)
        } else if let error = error {
            print(error)
        }
    }
    .progress { progressData in
        print(progressData)
    }

// in case you want to cancel the request
if someConditionIsSatisfied {
    request.cancel()
}
```

```swift
// Download to URL
let fileManager = FileManager.default
let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
let destURL = directoryURL.appendingPathComponent("myTestFile")
let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
    return destURL
}
client.files.download(path: "/test/path/in/Dropbox/account", overwrite: true, destination: destination)
    .response { response, error in
        if let response = response {
            print(response)
        } else if let error = error {
            print(error)
        }
    }
    .progress { progressData in
        print(progressData)
    }


// Download to Data
client.files.download(path: "/test/path/in/Dropbox/account")
    .response { response, error in
        if let response = response {
            let responseMetadata = response.0
            print(responseMetadata)
            let fileContents = response.1
            print(fileContents)
        } else if let error = error {
            print(error)
        }
    }
    .progress { progressData in
        print(progressData)
    }
```

> 두가지의 공통점은 파일을 다운로드하고, 업로드할 때 `경로`가 필요하다는 점이다. 메모장 프로젝트의 경우 CoreData를 통해서 메모를 관리하고 있기 때문에 `백업`의 형태로 CoreData의 경로를 얻어내서 `.sqlite`, `.sqlite-shm`, `.sqlite-wal` 총 3개의 파일을 업로드 및 다운로드 해주도록 구현해주었다.

> 업로드, 다운로드 모두 파일을 덮어쓸건지에 대한 옵션이 있으니 자세한건 아래 도큐먼트에서 검색해보면 되겠다.

https://dropbox.github.io/SwiftyDropbox/api-docs/latest/index.html


</div>
</details>


## 3-5 PR 후 개선사항
    
* 다운로드 중일 때 터치를 제한하는 것이 아니라 indicator가 추가된 컨트롤러로 화면을 덮기
* 다운로드, 업로드의 에러처리를 할 수 있도록 개선
* PersistentManager의 discardableResult 옵션을 제거
* NotesViewController의 setEditing 내부 if문 로직을 deleteCell 메소드로 이동
    
[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#동기화-메모장)

# STEP 4 : 추가 기능 및 UI 구현

* 지역화, 접근성, 검색기능 등을 추가 구현합니다.
    
## 4-1 고민했던 것

### 1. 검색 기능

* 검색어를 입력할 때마다 검색어에 해당하는 메모를 `실시간`으로 보여줄 수 있도록 `NSPredicate`를 활용하여 fetch하는 기능을 추가
* 검색어가 `빈 문자열("")`이라면 다시 메모의 전체목록을 보여줄 수 있도록 구현
    
### 2. 지역화 

* `언어` 영어를 기본설정으로 하고 한국어에 대해서도 다국어화를 지원하도록 구현
* `날짜` 시간은 시스템 시간을 따르도록 하고, 날짜 형식은 언어에 따라 포맷을 변경되도록 구현
    
### 3. 접근성
    
* 우측 메모 상세 내용의 경우 VoiceOver가 리스트를 읽은 후, 텍스트를 바로 읽어주는 것을 확인하고, `메모 내용`이라는 `accessibilityLabel`을 추가하여, 메모 텍스트를 읽기 전에 좀 더 화면의 구성요소를 이해하기 쉽도록 구현
* View의 텍스트 요소들에 `Dynamic Type`을 적용하여 사용자가 원하는 사이즈로 텍스트 크기를 설정할 수 있도록 유연성을 제공

## 4-2 의문점
    
* `Cancel`이나 `OK` 같은 것들은 자동으로 지역화가 되지 않는걸까?
* `UITableView`에는 `accessibilityLabel`을 추가해줄 수 없는걸까?
* CoreData를 불러오는 `fetch` 기능은 여러번하면 비용이 많이 드는걸까...?
* Dropbox에서 백업했던 파일을 다운로드해서 CoreData를 덮어쓰면 데이터베이스 에러가 나는데, 앱은 정상적으로 작동한다. 이 부분은 신경쓰지 않아도 될까?
    
## 4-3 Trouble Shooting

### 접근성을 위해 Accessibility Inspector를 활용

![](https://i.imgur.com/VP2HGaV.png)

* Accessibility Inspector를 활용하여 접근성을 위해 Run Audit을 통해 개선할 항목들이 없는지 검수하였다.
* 그리고 VoiceOver를 직접 실행해서 테스트해보며 부족한 부분이 있는지 확인해보았다.
* 다이나믹 타입의 경우도 텍스트 크기가 유연한지 검수하였다.
    
## 4-4 배운 개념

<details>
<summary>[Localization]</summary>
<div markdown="1">

# Localization

### 지역화란?
* 지역화는 현지화한다는 뜻을 가졌다
* 즉, 해당 언어와 나라 지역에 맞게 앱을 설정해주는 것을 뜻한다.
* 국제화(internationalization)를 I18N or i18n으로, 지역화(localization)를 L10N이나 l10n으로 표기한다

### 지역화의 전제조건
* 해당 앱이 지역화가 되려면 여러 국가에 배포되어 국제화 되어있는 앱이라는 조건이 있어야 한다.
* 해당 앱이 한국에서만 사용되는 앱이라면 지역화가 의미 없을 것이다.

### 지역화 가능한 요소
* RTL, LTR (문화권에 따른 읽기/쓰기 방식), 언어, 시간, 날짜, 주소, 화폐단위 및 통화, 이미지 등등...

### 지역화와 접근성의 관계
* 지역화를 함으로 여러 국가와 지역에서 해당 앱에 대한 접근성(accessibility)가 우수해진다.
* 접근성은 애플의 가장 강점인 부분으로 꼭 이 부분을 잘 활용하여 구현해놓으면 좋다.
    * 접근성(accessibility)을 설정하려면 accessibility inspector를 활용하여 여러가지를 구현할 수 있다.

### 언어 지역화
* 지역화 하려는 언어를 프로젝트에 추가한다.
    * 타겟을 선택해서 다국어화

![](https://i.imgur.com/LXGcj3d.png)

*  코드로 다국어 처리
    * Strings 파일을 생성하고
        * `Localizable.strings` 로 네이밍 변경

![](https://i.imgur.com/WoU9xAR.png)

* Localize... 버튼 클릭

![](https://i.imgur.com/y32fgtE.png)

* 다시 타겟으로 돌아가서 지역화하고 싶은 언어를 추가해주기 

![](https://i.imgur.com/vbkbUyR.png)

* 아까 만든 파일을 체크해주고 Finish

![](https://i.imgur.com/nHotMZL.png)

* 프로젝트에 파일이 생성되어 있는 모습

![](https://i.imgur.com/jcCIwcf.png)

![](https://i.imgur.com/yclkqR1.png)

* Localizable.strings에 다국어 처리를 햅주면 되는데, Key와 Value로 다국어 처리를 해줄 수 있다.

![](https://i.imgur.com/6bOA2a5.png)

![](https://i.imgur.com/ne1UxDS.png)

* 그리고 다국어화 한 문자열을 사용할 땐 `NSLocalizedString` 메소드를 활용해주어야 하는데, 번거로우니 extension을 활용하여 간단히 사용해볼 수 있다.

```swift
test.text = String(format: NSLocalizedString("Test", comment: ""))

// String Extension for Localization
extension String {
    var localized: String {
    	return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
text.text = "Test".localized
```
> 스토리보드를 코드로 말고 Interface Builder Storyboard 옵션을 활용하여 스토리보드 자체를 지역화해줄 수도 있다.

![](https://i.imgur.com/x8neP9B.png)

> 앱의 언어를 바꿀 때는 App Language, App Region 둘다 바꿔주자.
![](https://i.imgur.com/sR5vqSC.png)

> 이미지의 지역화는 Assets에 접근해서 이미지를 클릭후 우측 인스펙터에서 Localization을 활성화 시켜주면 된다.
![](https://i.imgur.com/xCXc1AU.png)

> 날짜 지역화

```swift
let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        dateTimeLabel.text = date
```

> 통화 지역화

```swift
func currency(text: Double) -> String? {
    let locale = Locale.current
    let price = text as NSNumber
    let formatter = NumberFormatter()

    formatter.numberStyle = .currency
    formatter.currencyCode = locale.languageCode
    formatter.locale = locale

    return formatter.string(from: price)
}

currencyLabel.text = currency(text: 3000.34)
```

> 뷰의 방향을 지역화 (방향 바꿀 때에도 유용하게 쓰는 듯?)

```swift
view.semanticContentAttribute = .forceRightToLeft
```

> 여러 문자열들을 지역화할 때 구글 스프레드 시트를 활용하기

![](https://i.imgur.com/U4VhRNW.png)

* 구글 스프레드 시트를 새로 생성한 후 위 사진과 같이 국가코드와 번역할 문장을 적으면 된다.
* 좌측에 국제코드를 적고 우측에 아래 코드를 적으면 번역한 문장이 생성된다. ([국가코드 참고사이트](https://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html))
```
// 예시
=GOOGLETRANSLATE("Welcome to yagom-academy", "en", A10)
```

### Localization을 할 때 유의할 점

* 국가별로 제공하는 기능이 다르게 해야하는 점도 참고하자.
* 국가별 기능차이를 두는 이유는 특정 화면이나 기능이 특정 나라에서는 사용하면 안되는 것이라던지, 특정 나라에 효과적으로 런칭하기 위해 새로운 기능을 도입한다던지, 비즈니스 적인 이유가 다양하다.


</div>
</details>

</br>
    
[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#동기화-메모장)
