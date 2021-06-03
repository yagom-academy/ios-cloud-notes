//
//  TableViewController.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

class MemoListViewController: UITableViewController {
  private let titleString = "메모"
  private let tableViewModel: MemoListViewModel = MemoListViewModel()
  
  lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    return button
  }()
  
  @objc func addMemo() {
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = addButton
    self.navigationItem.title = titleString
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewModel.getNumberOfMemo()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  // MARK: - Table view Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
