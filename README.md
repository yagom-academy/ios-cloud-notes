# 동기화 메모장 프로젝트 저장소



### 목차

- 기능
- 설계, 구현



## 기능

- 메모 리스트가 있고, 선택하면 메모의 내용을 볼 수 있다. 텍스트는 편집이 가능하다. (UI는 모두 코드로 구현)
- 가로가 Compact Size일 때는 행을 클릭하면 상세뷰로 넘어감
- 가로가 Regular Size일 때는 Split View로 전환되어 두번째 뷰가 오른쪽에 표시되도록 구현

| Compact Size                                                 | Regular Size 로 전환                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/28389897/132850423-948c75de-edc2-4502-913f-065662b929b4.gif" alt="11" style="zoom:60%;" /> | <img src="https://user-images.githubusercontent.com/28389897/132850374-bbfb9738-0e10-4a66-8c5c-0830980b6f0a.gif" alt="22" style="zoom:67%;" /> |



## 설계, 구현

### Step1

#### UML

![CloudNotes drawio2](https://user-images.githubusercontent.com/28389897/132954230-a9c9d588-f61a-4db3-8d0c-dab50c8f462d.png)



#### MVVM 패턴으로 리팩토링

![MVVM](https://user-images.githubusercontent.com/28389897/132761665-4c046f2c-eb36-44ac-b0df-b60e4bc62ef6.png)

- Model: 데이터를 캡슐화
- View: UI 같은 시각적인 요소를 관리
- ViewModel: Model데이터를 View에 맞게 가공, 처리

