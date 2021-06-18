//
//  TableViewController.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

final class MemoListViewController: UITableViewController {
  private let reuseIdentifier = "memoReuseCell"
  private let titleString = "메모"
  private let tableViewModel: MemoListViewModel = MemoListViewModel()
  
  var delegate: MemoListViewDelegate?
  
  lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    return button
  }()
  
  @objc func addMemo() {
    delegate?.touchAddButton()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBarButton()
    configureTableView()
  }
  
  private func configureNavigationBarButton() {
    navigationItem.rightBarButtonItem = addButton
    navigationItem.title = titleString
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MemoListCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewModel.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
  -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
            as? MemoListCell else {
      return UITableViewCell()
    }
    guard let viewModel = tableViewModel.getMemoListCellModel(for: indexPath) else {
      return UITableViewCell()
    }
    cell.configure(with: viewModel)
    return cell
  }
  
  // MARK: - Table view Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let splitViewController = splitViewController as? SplitViewController else { return }
    guard let detailViewController = splitViewController.viewController(for: .secondary)
            as? MemoDetailViewController else {
      return
    }
    guard let memo = tableViewModel.getMemo(for: indexPath) else { return }
    detailViewController.configure(with: memo, indexPath: indexPath)
    showDetailViewController(detailViewController, sender: self)
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, _ in
      self.delegate?.touchDeleteButton(indexPath: indexPath)
    })
    let shareAction = UIContextualAction(style: .normal, title: "Share", handler: {
      _, _, _ in
      self.delegate?.touchShareButton(indexPath: indexPath)
    })
    return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
  }
}
