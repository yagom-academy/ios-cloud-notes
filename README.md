
# 동기화 메모장 프로젝트

## 목차
- [STEP1 : 모델/네트워킹 타입 구현](##STEP1-메모-리스트-및-내용-화면의-UI-구현)
    + [키워드](#1-1-키워드)
    + [구현 내용](#1-2-구현-내용)
    + [고민한 점](#1-3-고민한-점)

- [STEP2 : CoreData DB 구현](##STEP2-CoreData-DB-구현)
    + [키워드](#2-1-키워드)
    + [구현 내용](#2-2-구현-내용)
    + [고민한 점](#2-3-고민한-점)

- [STEP3 : 클라우드 연동](##STEP3-클라우드-연동)
    + [키워드](#3-1-키워드)
    + [구현 내용](#3-2-구현-내용)
    + [고민한 점](#3-3-고민한-점)

- [STEP4 : 추가 기능 구현](##STEP4-추가-기능-구현)
    + [키워드](#4-1-키워드)
    + [구현 내용](#4-2-구현-내용)
    + [고민한 점](#4-3-고민한-점)

## 프로젝트 소개

|**메모 추가**|![](https://i.imgur.com/8NgYdVX.gif)|
|:--:|:--:|
|**메모 삭제**|![](https://i.imgur.com/YNz6R4t.gif)|
|**메모 업데이트**|![](https://i.imgur.com/U3rk1Gh.gif)|
|**CoreData**|![](https://i.imgur.com/ZjdfTg5.gif)|
|**DropBox 연동**|![](https://i.imgur.com/qTF2Var.gif)|
|**Dark Mode**|![](https://i.imgur.com/bjZaHnm.gif)|
|**접근성**|![](https://i.imgur.com/l3M8FTE.gif)|
|**메모 검색**|![](https://i.imgur.com/EkSJAyx.gif)|

## STEP1 메모 리스트 및 내용 화면의 UI 구현
### 1-1 키워드
- iPad, UISplitViewController
- Dependency Injection
- ARC, Weak References
- Delegate Pattern
- JSON, Decoding
- DateFormatter
- ContentOffset/ContentInset
- Dynamic type
- keyboardWillShowNotification
- Swift Lint, Cocoa Pod

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

### 1-3 고민한 점
#### 1. delegate 패턴
SplitView의 ChildView인 MasterTableViewController 및 DetailViewController 간의 의존성을 낮추기 위해 delegate 패턴을 사용했습니다.

MasterView가 MemoSelectionDelegate 프로토콜 타입의 delegate를 가지고, DetailView가 MemoSelectionDelegate 프로토콜을 채택하도록 했습니다.

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

```swift
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


## STEP2 CoreData DB 구현
### 2-1 키워드
- CoreData CRUD
- SwipeActionConfiguration
- UIPopoverPresentationController
- ActionSheet/Alert
- UIAcitivityView
- NSMutableAttributedString

### 2-2 구현 내용
- 싱글톤 CoreDataManager을 통해 CoreData CRUD 기능을 구현했습니다. 사용자가 수정한 메모를 실시간으로 CoreData에 저장하고, 목록에 나타내도록 했습니다. 
- 메모 우상단의 더보기 버튼과 Cell Swipe 버튼을 통해 메모 공유/삭제 기능을 구현했습니다.
- TextView의 메모 내용 중 첫 줄은 Title이 되고, 줄바꿈 이후부터 Body가 되도록 구현했습니다.
- (요구사항 외) 앱 테스트를 원활히 진행하고자 TableView 상단의 +버튼을 통해 새 메모를 추가하도록 임시 기능을 구현했습니다.

#### 코드 구조
- Model
- View
- Controller
- 기타
- CoreData

### 2-3 고민한 점 
#### 1. 범용성 있는 CoreDataManager
메모 데이터를 담고 있는 memos 배열을 CoreData와 TableViewDataSource 중에 어디에 저장해야 할지에 대해 고민했습니다.

CoreDataManager를 범용성 있는 Utility 기능으로 구현하고 싶었기 때문에 CoreData가 memos를 가지지 않도록 하는 게 적절하다고 판단했습니다. 

따라서 TableViewDataSource가 가지도록 했습니다. 또한 CoreDataManager의 fetch/delete 메서드 등도 확장성을 고려하여 제네릭 타입으로 생성했습니다.

#### 2. MasterTableViewController 및 DetailViewController의 관계
DetailView에서 받은 사용자 입력값을 어떻게 TableView List에 반영할지에 대해 고민했습니다.

SplitViewController에 담겨있는 Master 및 Detail View의 의존성을 낮추기 위해 서로 모르도록 했습니다. 따라서 사용자가 DetailView에서 텍스트를 입력하거나, 메모를 삭제할 때 NofiticationCenter를 사용하여 MasterView에게 알려주도록 했습니다.

그런데 기능을 추가하다보니 프로젝트 특성상 두 View의 연관성이 높을 수 밖에 없는 상황이라 서로 모르도록 한 것이 맞는 방향인지 의문이 들었습니다.

#### 3. 사용자 입력값을 TableView에 반영하기
사용자가 TextView에 입력한 내용을 TableView의 List에도 즉시 반영하기 위해 TextViewDelegate의 `shouldChangeTextIn` 메서드를 활용했습니다.

하지만 확인해보니 사용자 입력값이 1개 문자씩 delay되어 반영되는 문제가 발생하여 `textViewDidChange` 메서드를 활용하도록 변경했습니다.

#### 4. 메모의 첫 번째 줄은 제목으로, 그 다음 줄부터 본문으로 구분
`shouldChangeTextIn` 메서드에서 `\n`으로 구분하여 TextView의 첫번째 줄은 Title로, 그 이외에는 Body로 설정해주어 CoreData에 저장했습니다.

```swift 
extension DetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]

        let text = textView.text as NSString
        let titleRange = text.range(of: "\n")  // titleRange : 줄바꿈이 처음 나올 때까지의 range

        if titleRange.location >= range.location {  // range.location : 현재 입력한 텍스트 (range 매개변수)의 location 
            self.textView.typingAttributes = titleAttributes
        } else {
            self.textView.typingAttributes = bodyAttributes
        }

        return true
    }
}
```
이때 TextView에서 Title 및 Body를 구분하여 효과를 적용하기 위해 `NSMutableAttributedString`을 사용했습니다.

```swift 
private func updateTextView() {
    let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1),
                           NSAttributedString.Key.foregroundColor: UIColor.label]
    let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                          NSAttributedString.Key.foregroundColor: UIColor.label]

    let totalAttributedText = NSMutableAttributedString()
    let titleAttributedText = NSMutableAttributedString(string: memo?.title ?? "", attributes: titleAttributes)
    let bodyAattributedText = NSMutableAttributedString(string: "\n\n\(memo?.body ?? "")", attributes: bodyAttributes)

    totalAttributedText.append(titleAttributedText)
    totalAttributedText.append(bodyAattributedText)

    textView.attributedText = totalAttributedText
}
```

## STEP3 클라우드 연동
### 3-1 키워드
- Cloud, Data Synchronization
- SwiftyDropbox, Cocoa Pod
- SFSafariViewController

### 3-2 구현 내용
- 클라우드 (Dropbox) 연동을 위해 Cocoa Pod 및 SwiftyDropbox 라이브러리를 활용했습니다.
- 코어데이터를 다른 기기와 동기화 할 수 있도록 DropBoxManager 타입 및 uploadToDropBox/downloadFromDropBox 메서드를 구현했습니다.
- 클라우드 다운로드 
    - 시점 : 앱 실행 시 초기화면에서 DropBox Safari ViewController를 present하고, DropBox 로그인이 성공했을 때 다운로드 하도록 구현하였습니다. (추후 로그인 실패 후 다시 로그인 시도를 할 수 있도록 버튼을 추가할 예정입니다.)
    - 클라우드의 데이터를 다운로드하여 저장하는 위치는 PersistentContainer의 defaultDirectoryURL으로 설정했고, overwrite 모드로 구현하였습니다.
- 클라우드 업로드 
    - 시점 : 메모 추가/삭제할 때, 메모 업데이트할 때 (textViewDidEndEditing 메서드) 업로드를 하도록 구현하였습니다.
    - 메모를 추가/삭제/수정할 때, 클라우드에 저장되어있는 데이터와 사용자의 CoreData에 저장되어 있는 데이터는 일치하므로 클라우드의 데이터를 다운받을 때 Overwrite를 하여도 문제가 없도록 구현하였습니다.

#### 코드 구조
- Utility
    - DropBoxManager 클래스 : SafariViewController를 나타내어 사용자가 로그인할 수 있게 하고, CoreData의 데이터를 Dropbox에 업로드/다운로드함
- 기타
    - AppDelegate/info.plist : Dropbox AppKey, LSApplicationQueriesSchemes/URL types 정보를 등록함
    
### 3-3 고민한 점 
#### 1. Download와 Upload의 시점

클라우드를 이용한 메모이기에, 어떤 시점에서 클라우드를 통해 데이터를 주고 받을 지에 대한 고민을 해보았습니다.

아무래도 모든 메모는 사용자가 직접 수정 또는 추가하기 전에 가장 최신버전의 메모에 기입을 해야한다고 생각을 해서, Download는 앱의 Scene Delegate에 구현을 해주었습니다.

그리고 반대로, 사용자가 모든 메모의 작성이 끝나면 Upload가 되어야한다고 생각을 했기에, 실제 메모를 적을 수 있는 textView의 Delegate인 `textViewDidEndEditing` 에 구현을 해주었습니다.

#### 2. DropBox 업로드/다운로드 오류 (***해결 후 업데이트 예정***)
`uploadToDropBox` 메서드로 클라우드 업로드 (overwrite)를 할 때, 처음에는 문제가 없었는데 갑자기 DropBox의 3개 sqlite 파일 중 1개 (CloudNotes.sqlite)만 업데이트가 안되는 문제가 발생했습니다.

CoreData가 저장된 `Application Support` 폴더 내부의 파일을 확인해봤는데, CoreData 파일은 정상적으로 업로드된 것을 확인했습니다. 그리고 업로드 response 출력문을 확인했을 때 3개 파일 모두 정상적으로 업로드된 것을 확인했습니다.

![](https://i.imgur.com/TK1ZijW.png)

왜 DropBox 폴더에서만 이러한 문제가 발생하는지 파악하고자 콘솔창의 에러문구를 모두 검색해봤지만 해결할 수 없었습니다.

```
// 다운로드 시 발생
CoreData: error: -executeRequest: encountered exception = I/O error for database at /Users/hyojuson/Library/Developer/CoreSimulator/Devices/05F35EA9-9E39-492C-8223-F54BBC92A49F/data/Containers/Data/Application/5D565A17-0D9F-4738-A637-D2A9DA49FFE9/Library/Application Support/CloudNotes.sqlite.  SQLite error code:6922, 'disk I/O error' with userInfo = {
    NSFilePath = "/Users/hyojuson/Library/Developer/CoreSimulator/Devices/05F35EA9-9E39-492C-8223-F54BBC92A49F/data/Containers/Data/Application/5D565A17-0D9F-4738-A637-D2A9DA49FFE9/Library/Application Support/CloudNotes.sqlite";
    NSSQLiteErrorDomain = 6922;
}

[error] error: (6922) I/O error for database at /Users/hyojuson/Library/Developer/CoreSimulator/Devices/05F35EA9-9E39-492C-8223-F54BBC92A49F/data/Containers/Data/Application/5D565A17-0D9F-4738-A637-D2A9DA49FFE9/Library/Application Support/CloudNotes.sqlite.  SQLite error code:6922, 'disk I/O error'

// 다운로드 및 업로드 시 발생
[logging] BUG IN CLIENT OF libsqlite3.dylib: database integrity compromised by API violation: vnode unlinked while in use: /Users/hyojuson/Library/Developer/CoreSimulator/Devices/05F35EA9-9E39-492C-8223-F54BBC92A49F/data/Containers/Data/Application/5D565A17-0D9F-4738-A637-D2A9DA49FFE9/Library/Application Support/CloudNotes.sqlite-wal
```


## STEP4 추가 기능 구현
### 4-1 키워드
- Accessibility, Dynamic Type, Dark/Light Mode
- UISearchController, UISearchResultTableViewController, SearchBar

### 4-2 구현 내용
- 메모 List 상단의 SearchBar를 통해 사용자가 메모를 검색하는 기능을 구현했습니다. 그리고 Dark/Light Mode에 모두 대응하도록 기능을 추가했습니다.

#### 코드 구조
- Controller
    - SearchResultTableViewController 클래스 : SearchBar의 입력값을 전달받아 전체 메모 (memos 배열) 중 입력값을 포함하는 메모 (filteredMemos 배열)를 필터링하고, 검색 결과를 새로운 TableView 형태로 나타냄

#### 1. SearchBar 추가
메모 목록 상단에 SearchBar를 구현했습니다. 사용자의 입력값을 제목 또는 본문에 포함하고 있는 메모를 검색결과로 보여주도록 했습니다.

이를 위해 Custom TableViewController인 `searchResultViewController` 타입을 추가했습니다. 그리고 `MaterTableViewController`에서 초기화했고, 생성자 주입을 통해 `MaterTableViewController`의 DataSource의 memos를 전달하도록 했습니다. 

그리고 SearchBar에 텍스트를 입력할 때마다 호출되는 `updateSearchResults` 메서드 내부에서 `searchResultViewController`의 `searchMemo` 메서드를 호출하여 메모를 필터링했습니다.

```swift=
final class MasterTableViewController: UITableViewController {
    private(set) var memoDataSource: MasterTableViewDataSourceProtocol?
    weak var delegate: MemoSelectionDelegate?
    lazy var searchResultViewController = SearchResultTableViewController(memos: memoDataSource?.retrieveMemos(), delegate: delegate)
// ...
}
```

처음에는 `searchResultViewController`와 `masterTableViewController`가 모두 동일한 memos 배열 데이터를 사용하므로 기존의 DataSource를 두 ViewController 모두 사용하도록 시도했습니다. 

그런데 이 과정에서 타입캐스팅을 위해 DataSource가 ViewController를 알고 있어야하는 문제가 있었고, 의존성이 다시 높아진다고 판단하여 이 방법을 사용하지 않았습니다.


#### 2. Dark Mode 미지원 레이블 추가적으로 지원
테이블 뷰의 텍스트들은 DarkMode를 지원했지만, `DetailView`의 텍스트뷰의 텍스트는 지원이 안되고 있어 이를 수정해주었습니다.

```swift
// 수정 전
let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)]
let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]

// 수정 후
let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1),
                       NSAttributedString.Key.foregroundColor: UIColor.label]
let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                      NSAttributedString.Key.foregroundColor: UIColor.label]
```

### 4-3 고민한 점 
#### 1. 메모 추가 직후 검색 (***해결 후 업데이트 예정***)
기존에 있던 메모를 검색하는 작업은 괜찮았지만 새 메모를 추가직후에 해당 메모는 검색이 안되는 버그가 있습니다.

#### 2. 메모 검색 후 삭제
특정 메모를 검색한 뒤 메모를 삭제하면 코어데이터나, 검색창을 끈 뒤의 테이블뷰에서는 정상적으로 삭제가 되는데 검색창을 띄운 상태에선 삭제가 되지 않는 버그가 있습니다.



