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
  }
}

extension SplitViewController: UISplitViewControllerDelegate {
  func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
    return .primary
  }
}

extension SplitViewController: MemoListViewDelegate {
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
    present(activityView, animated: true, completion: nil)
  }
}

extension SplitViewController: MemoProviderDelegate {
  func memoDidCreate(_ memo: Memo, indexPath: IndexPath) {
    guard let memoListViewController = self.viewController(for: .primary) as? MemoListViewController,
          let memoDetailViewController = self.viewController(for: .secondary) as? MemoDetailViewController else { return }
    memoListViewController.tableView.reloadData()
    showDetailViewController(memoDetailViewController, sender: self)
  }
  
  func memoDidUpdate(indexPath: IndexPath, title: String, body: String) {
    memoListViewController?.tableView.reloadData()
  }
  
  func memoDidDelete(indexPath: IndexPath) {
    memoListViewController?.tableView.reloadData()
  }
}
