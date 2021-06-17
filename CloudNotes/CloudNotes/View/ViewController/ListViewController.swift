//
//  ListViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/05/31.
//

import UIKit

final class ListViewController: UIViewController {
  weak var delegate: ListViewControllerDelegate?
  static let titleText = "메모"
  let viewModel = ListViewModel()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    configureNavigationBar()
    view.addSubview(tableView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  
  func configureNavigationBar() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self,
                                    action: #selector(buttonPressed(_:)))
    navigationItem.rightBarButtonItem = addButton
  }
  
  @objc private func buttonPressed(_ sender: Any) {
    // FIXME: - 네비게이션 바가 출력되지않는 오류
    MemoDataManager.shared.createMemo() {
      self.updateTable()
      self.viewModel.setMemoInfoList()
      
      let memoInfo = self.viewModel.memoInfo(at: 0)
      self.delegate?.didTapMenuItem(model: memoInfo)
    }
  }
  
  func updateTable() {
    viewModel.setMemoInfoList()
    tableView.reloadData()
  }
}

extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let memoInfo = viewModel.memoInfo(at: indexPath.row)
    delegate?.didTapMenuItem(model: memoInfo)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, _ in
      let memoInfo = self.viewModel.memoInfo(at: indexPath.row)
      self.delegate?.didSwipeForDeleteMenuItem(model: memoInfo) {
        // TODO: - delete logic: cell hidden
//        tableView.deleteRows(at: [indexPath], with: .fade)
//        self.tableView.reloadData()
      }
    }
    let shareAction = UIContextualAction(style: .normal, title: "공유") { _, _, _ in
      // TODO: - share logic
    }
    return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
  }
}

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewModel.numOfMemoInfoList
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier,
                                                   for: indexPath) as? ListCell else {
      return UITableViewCell()
    }
    
    let memoInfo = viewModel.memoInfo(at: indexPath.row)
    cell.update(info: memoInfo)
    
    return cell
  }
}
