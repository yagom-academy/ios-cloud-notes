//
//  MainSplitViewController.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

final class SplitViewController: UISplitViewController {
  
  private var memoListViewController: MemoListViewController?
  private var memoDetailViewController: MemoDetailViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    MemoProvider.shared.delegate = self
    setPreferredStyle()
    setSubViewControllers()
  }
  
  private func setPreferredStyle() {
    preferredSplitBehavior = .tile
    preferredDisplayMode = .oneBesideSecondary
  }
  
  private func setSubViewControllers() {
    memoListViewController = MemoListViewController()
    memoDetailViewController = MemoDetailViewController()
    self.setViewController(memoListViewController, for: .primary)
    self.setViewController(memoDetailViewController, for: .secondary)
    memoListViewController?.delegate = self
    memoDetailViewController?.delegate = self
  }
}

extension SplitViewController: UISplitViewControllerDelegate {
  func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
    return .primary
  }
}

extension SplitViewController: MemoListViewDelegate {
  func deleteEmptyMemo() {
    guard let memo = MemoProvider.shared.memos?.first else { return }
    let indexPath = IndexPath(row: 0, section: 0)
    guard let title = memo.title, let body = memo.body else {
      MemoProvider.shared.deleteMemoData(indexPath: indexPath)
      return
    }
    if title.isEmpty == true && body.isEmpty == true {
      MemoProvider.shared.deleteMemoData(indexPath: indexPath)
    }
  }
  
  func touchAddButton() {
    MemoProvider.shared.createMemoData()
  }
  
  func touchDeleteButton(indexPath: IndexPath) {
    MemoProvider.shared.deleteMemoData(indexPath: indexPath)
  }
  
  func touchShareButton(indexPath: IndexPath) {
    guard let memos = MemoProvider.shared.memos else { return }
    guard let title = memos[indexPath.row].title else { return }
    let activityView = UIActivityViewController(activityItems: [title], applicationActivities: nil)
    memoListViewController?.present(activityView, animated: true, completion: nil)
  }
}

extension SplitViewController: MemoProviderDelegate {
  func presentAlertController(_ alert: UIAlertController) {
    self.present(alert, animated: true, completion: nil)
  }
  
  func memoDidCreate(_ memo: Memo, indexPath: IndexPath) {
    guard let memoListViewController = memoListViewController,
          let memoDetailViewController = memoDetailViewController else { return }
    memoDetailViewController.configure(with: memo, indexPath: indexPath)
    memoListViewController.tableView.insertRows(at: [indexPath], with: .automatic)
    showDetailViewController(memoDetailViewController, sender: self)
  }
  
  func memoDidUpdate(indexPath: IndexPath, title: String, body: String) {
    let firstIndex = IndexPath(row: .zero, section: .zero)
    memoListViewController?.tableView.moveRow(at: indexPath, to: firstIndex)
    memoListViewController?.tableView.reloadRows(at: [firstIndex], with: .none)
  }
  
  func memoDidDelete(indexPath: IndexPath) {
    memoListViewController?.tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}

extension SplitViewController: MemoDetailViewDelegate {
  func textViewDidChanged(indexPath: IndexPath, title: String, body: String) {
    MemoProvider.shared.updateMemoData(indexPath: indexPath, title: title, body: body)
    memoDetailViewController?.changeIndex(IndexPath(row: 0, section: 0))
  }
}
