//
//  ListViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/05/31.
//

import UIKit

final class ListViewController: UIViewController {
  weak var delegate: ListViewControllerDelegate?
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
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    navigationItem.rightBarButtonItem = add
  }
}

extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let memoInfo = viewModel.memoInfo(at: indexPath.row)
    delegate?.didTapMenuItem(model: memoInfo)
        
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewModel.numOfMemoInfoList
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: ListCell = tableView.dequeueReusableCell(
            withIdentifier: ListCell.identifier,
            for: indexPath) as? ListCell else {
      return UITableViewCell()
    }
    
    let memoInfo = viewModel.memoInfo(at: indexPath.row)
    cell.update(info: memoInfo)
    
    return cell
  }
}
