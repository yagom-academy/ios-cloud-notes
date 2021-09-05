## iOS 커리어 스타터 캠프

### 알게된점

1. 내가 만든 split view controller는 항상 root가 되어야한다.
```
애플 공식 문서:
  A split view controller must always be the root of any interface you create. 
  In other words, you must always install the view from a UISplitViewController object as the root view of your application's window.
  The panes of your split-view interface may then contain navigation controllers, tab bar controllers,
  or any other type of view controller you need to implement your interface.
```
그렇기에 sceneDelegate에서 rootViewController를 만들 때 navigtionController에 splitViewController를 추가해주는 방식에서 바로 splitViewController를 생성해주었다
   
2. preferredSplitBehavior에서 property
![splitbehavior](https://user-images.githubusercontent.com/65723901/132115844-bad40151-999a-4571-8d68-aa29f28553a3.png)
- tile는 화면의 크기가 줄어들때 이미지가 압축되어서 전체 이미지가 화면에 표시된다. 
- overlay는 primary가 이미지위에 덮어지는 형태로 보여진다.
- displace는 이미지가 옆으로 밀려서 이미지의 일부만 화면에 표시된다.
처음에 displace로 preferredSplitBehavior를 설정해주어서 debugarea에 이상한 로그가 찍혔었다. 그 이유가 내 생각에는 텍스트뷰를 어디까지 밀어줄지 명시해주지 않아서 생긴게 아닐까라는...

3. UISplitViewControllerDelegate
```
func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column
```
를 통해서 띄워줄 화면을 선택할 수 있엇다.
