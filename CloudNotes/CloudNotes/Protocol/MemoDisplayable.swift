protocol MemoDisplayable: AnyObject {
  func showMemo(title: String?, body: String?)
  func set(editable: Bool, needClear: Bool)
}
