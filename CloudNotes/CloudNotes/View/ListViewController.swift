//
//  ListViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/05/31.
//

import UIKit

class ListViewController: UIViewController {
  let viewModel = ListViewModel()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    view.addSubview(tableView)
    
    configureNavigationBar()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  
  func configureNavigationBar() {
    self.navigationController?.navigationBar.topItem?.title = "메모"
    
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    navigationItem.rightBarButtonItem = add
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
 
// MARK: - for canvas
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = ListViewController
  
  func makeUIViewController(context: Context) -> ListViewController {
    return ListViewController()
  }
  
  func updateUIViewController(_ uiViewController: ListViewController, context: Context) {
  }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
  static var previews: some View {
    ViewControllerRepresentable()
  }
}
