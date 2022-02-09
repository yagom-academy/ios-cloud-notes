import Foundation

protocol MemoListViewControllerDelegate: AnyObject {
  func load(memo: Memo)
}
