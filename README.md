## iOS 커리어 스타터 캠프

### 동기화 메모장 저장소

# 🗒 동기화 메모장 프로젝트
기간 : 2021.08.30 ~ 2021.09.17
팀원 : 개인 Marco([keeplo](https://github.com/Keeplo))

# Index
  * [요구기능 상세](#Step-2-요구-기능)
  * [구현된 요구기능 시연](#구현된-요구기능-시연)
  * [새롭게 알게된 개념정리](#📝-새롭게-알게된-개념)
  * [고민한 내용정리](#🤔-고민한-내용)
  * [해결하지 못한 내용 및 도움 받은 내용](#🤯-해결하지-못한-내용-및-리뷰어의-도움을-받아-해결한-내용)
  * [더 공부할 내용](#➕-더-공부할-내용)

# Step 2 요구 기능
* 메모 데이터르 영구 저장하기 위한 CoreData 모델구현 
  - CoreData 저장소의 위치
  - 메모 CRUD 구현
* Primary Column TableView에서 Add 동작
  - TableViewCell의 swipe 동작으로 Delete 동작
* Secondary Column DetailView에서 **더보기** 동작 
  - ActivityView present
  - Delete 동작
* 사용자의 접근과 TextView 
  - TextView의 수정과 삭제 
  - 키보드 Show & Hide 동작
> Note  
> 앱의 디테일한 동작 방식은 정해진게 없다보니   
> Clone Coding 같은 접근으로 iOS, iPadOS의 기본 메모앱과 동일한 동작 방식을 구현해보았다.

# 구현된 요구기능 시연


# 새롭게 알게된 개념
* **Core Data**    
  애플에서 제공하는 `local object graph persistence framework`로 데이터를 영구 저장하는 목적으로 사용하는 프레임워크  
  내부 저장소는 Default로 Sqlite(관계형 DB)이지만 실제 동작은 객체지향 DB형태로 다루게 됨. 객체 그래프(Object Graph) 관리자로 볼 수 있음.  
  Core Data는 직접 DB(Sqlite)를 다룬다기보다 객체 그래프를 관리하기 때문에 ORM으로 볼 수 있음. 
  기본적으로 Thread Safe 하지 않음.  
  * Persistance Object Store (ex Sqlite)
  * Persistnace Store Coordinator : 컨텍스트의 요청을 받아서 영구 저장소에서 데이터르 탐색 및 불러오기  
  * Managed Object Context (NSManagedObjectContext) : CRUD를 하는 DAO 같은 역할
  * Managed Object Model : 엔티티로 볼 수 있음
  * Managed Object (NSManagedObject) : 엔티티를 인스턴스화 하는 데이터
  > 관련 문서   
  > [Archive - Core Data Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075-CH2-SW1)    
  > [Documentation - Core Data](https://developer.apple.com/documentation/coredata/)  
  > 

* **Keyboard 와 UIResponder UIEvent**  
  키보드 동작에 관련해서 iOS 자체적으로 일정 상황에 
  > 예를들어 [InputView](https://developer.apple.com/documentation/uikit/uiresponder/1621092-inputview)에 사용자가 터치해서 해당 View가 firstResponder가 되면 디바이스 software Keyboard가 등장한다,   
  > 해당 View가 resignFirstResponder가 되면 키보드는 숨김  
 
  UIKit 내부에 UIRespoder 클래스에서 타입 메서드로 해당 상황에 대한 Notification을 전달해준다.  
  이 Notification을 기초로 키보드의 동작을 추적할 수 있음.    
  
  **iOS 환경에서 사용자의 터치 이벤트를 제어**  
  * Responder Chain
  * Gesture Recognizer
  * Hit-testing    
  
  > 관련 문서   
  > [Archive - Text Programming Guide - Managing the Keyboard]()      
  > [Documentation - UIResponder](https://developer.apple.com/documentation/uikit/uiresponder)    
  > [Documentation - UIEvent](https://developer.apple.com/documentation/uikit/uievent/)    
  > [Article - Using Responders and the Responder Chain to Handle Events](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events)  
  > [Documentation - UIView - hitTest:withEvent:](https://developer.apple.com/documentation/uikit/uiview/1622469-hittest?language=objc)  
  
* **Activity View**  
  App 내에서 특정 정보를 복사하거나 외부 앱이나 서비스에 내보내기 하는 기능  
  기본적으로 UIViewController르 이용해서 **문자열(String)** / **URL(String)** / **UIImage** / **UIActivityItemSource** Protocol을 따르는 Custom 타입 인스턴스 등 정보르 내보내기 가능함
  
  > 관련 문서  
  > [HIG - Views - Activity Views](https://developer.apple.com/design/human-interface-guidelines/ios/views/activity-views/)    
  > [Documentation - UIActivity](https://developer.apple.com/documentation/uikit/uiactivity)    
  > [HIG - Extensions - Sharing and Actions](https://developer.apple.com/documentation/uikit/uiactivity)  
  > [Video - What's New in Sharing](https://developer.apple.com/videos/play/tech-talks/210/)  
  > [Video - Embedding and Sharing Visually Rich Links](https://developer.apple.com/videos/play/wwdc2019/262/)  
  > [Blog - UIActivityViewController](https://nshipster.com/uiactivityviewcontroller/)  

# 🤔 고민한 내용
1) UISwipeActionsConfiguration 과 tableView(_:editingStyleForRowAt:)중 ContextualAction 구현의 방식 고민하기   
  두 가지 방식이 비슷하게 블로그에서 설명하게 되는데 [tableView(_:editingStyleForRowAt:)](https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614869-tableview) 문서에 아래처럼 나온 내용을 보고
 ![image](https://user-images.githubusercontent.com/24707229/133891985-384a944e-93d2-46c4-8e5b-c79613e70bfd.png)  
 수정 모드로 변경해서 index 변경을 한다거나 다중 선택 등 기능을 위한 조건 처럼 보여서 UISwipeAction으 다루는 [tableView(_:leadingSwipeActionsConfigurationForRowAt:)](https://developer.apple.com/documentation/uikit/uitableviewdelegate/2902366-tableview) 메서드를 이용해서 구현해 봄

2) 메모 리스트를 보여줄 메모 배열의 위치 고민하기
  * 하나의 인스턴스를 참조하는 두 ViewController (Primary, Secondary)
  -> Container View에서 데이터를 다루는 게 좋을 지 실제로 사용할 Child ViewControllers에서 다뤄야 할 지 고민 
<details><summary>변화 과정 및 각 구현의 문제점 정리</summary>
<div markdown="1">

  **기존 위치**
  ```swift 
  // Step 1에서 List를 위한 Memo 배열 위치
  class PrimaryTableViewDataSource: NSObject {
    // ...
    private var memos: [Memo] = []
  }
  ```
  -> 문제점 : TableViewController와의 소통이 Container와 중복됨, SecondaryViewController와의 소통이 복잡함
  
  **AppDelegate에서 관리**
  ```swift
  // 첫번째 변경 아이디어 AppDelegate
  @main
  class AppDelegate: UIResponder, UIApplicationDelegate {
    var memos: [Memo] = []
  }

  // MARK: - TableView DataSource
  extension PrimaryViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memos.count
    }
  }
  ```
  -> 문제점 : 현재 앱에서 큰 문제가 되지 않지만 규모가 커진다면 Container를 벗어나 전역으로 관리하는 Resource는 좋지 않음..
  
  **DataManager**
  ```swift
  // CoreData Manager에서 해당 배열으 저장
  class MemoCoreDataManager {
    static let shared = MemoCoreDataManager()
    private var memos: [MemoData] {
  
  // MARK: - TableView DataSource
  extension PrimaryViewController {
    let coreManager MemoCoreDataManager.shared
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreManager.memos.count
    }
  }
  ```
  -> 상황에 따라 환경에 따라 다르겠지만 추후 CoreData(영구저장) 및 Cloud(동기화) 등 처리할 DataManager의 위치시킴
 
</div></details>
  
3) UML 그리기를 통해서 앱 전반의 모든 관계 고민해보기
  * Before
    <img width="1442" alt="before" src="https://user-images.githubusercontent.com/24707229/134320508-f9a1ffd3-b2a8-4f66-811a-fa786abec483.png">
    -> 두 Child Views가 Container ViewController의 인스턴스를 참조하면서 집합관계와 합성관게를 동시에 가지거나, 모든 ViewController에서 의존관계가 얽혀 있음
  * After
    <img width="1572" alt="Screen Shot 2021-09-17 at 12 56 01 AM" src="https://user-images.githubusercontent.com/24707229/134321846-6fe5e7c4-a69d-4f44-b719-6ba62296f70e.png">
    -> CoreDataManager가 데이터 Resource 역할을 하고 각 Child ViewController에 의존관계가 되는 형태로 변경
    

# 🤯 해결하지 못한 내용 및 리뷰어의 도움을 받아 해결한 내용
1) `navigationItem.rightBarButtonItems`에 추가한 Button이 동작을 하지 않는 현상  
  TextView를 기준으로 Keyboard가 등장하고 cursor가 활성화 되었을때는 더보기와 "Done" 버튼이 생성되고   
  숨김 처리될때는 더보기 버튼만 남아있느 형태로 애플 메모앱의 동작을 참고했다.
  Bug : 최초 Detail View가 등장하고 있는 더보기 버튼이 동작은 하지 않고 키보드 활성화 되서 버튼이 두 개로 바뀔때는 동작을 함..
  > Reviewer의 피드백으로 UIButton을 할당할때 `lazy` 키워드가 들어가야 하는 점을 배움..
 
<details><summary>예제코드</summary>
<div markdown="1">

```swift
// 수정전 
class SecondaryViewController: UIViewController {
  private var hidableDoneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                    target: self,
                                                    action: #selector(resignFromTextView))
  private var seeMoreStaticButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(tappingSeeMoreButton))
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      setBarButtons(isHide: true)
  }
  @objc func keyboardWasShown(_ notification: Notification) {
      setBarButtons(isHide: false)
    }
  @objc func keyboardWillBeHidden(_ notification: Notification) {
      setBarButtons(isHide: true)
  }
  func setBarButtons(isHide: Bool) {
      let items = isHide ? [seeMoreStaticButton] : [hidableDoneButton, seeMoreStaticButton]
      self.navigationItem.setRightBarButtonItems(items, animated: true)
  }
}
// 피드백 받고 수정 후
class SecondaryViewController: UIViewController {
  private lazy var hidableDoneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                    target: self,
                                                    action: #selector(resignFromTextView))
  private lazy var seeMoreStaticButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(tappingSeeMoreButton))
}
```
</div></details>

> 관련 문서  
> [UINavigationController](https://developer.apple.com/documentation/uikit/uinavigationcontroller)  
> [Developer Forums](https://developer.apple.com/forums/thread/106842)

2) Regular Size 화면에서 데이터처리
  다른 메모를 선택하면 작성 중이던 TextView가 `func textViewDidEndEditing(_ textView: UITextView)` 동작을 하지 않아 UI Update 가 이루어지지 않음.
  

<details><summary>예제코드</summary>
<div markdown="1">

```swift

```
</div></details>



# ➕ 더 공부할 내용
* NSFetchedResultsController
* CoreData Versioning 과 Migration [Archive](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreDataVersioning/Articles/vmMigrationProcess.html#//apple_ref/doc/uid/TP40004399-CH6-SW1)

