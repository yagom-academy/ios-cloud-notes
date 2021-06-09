//
//  CloudNotes - MemoListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MemoListViewController: UIViewController {
    var memoListViewModel: MemoListViewModel = MemoListViewModel()
    let memoListViewNavigationBarTitle: String = "메모"
    var memoDetailViewDelegate: MemoDetailViewDelegate?
    
    private var tableView: UITableView = UITableView()
    private let plusMemo = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

    init(detailViewDelegate: MemoDetailViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.memoDetailViewDelegate = detailViewDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemoListView()
        configurefirstMemo()
        tableViewAutoLayout()
    }
    
    private func configureMemoListView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.memoListViewModel.loadSampleData()
        
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.backgroundColor = .white
        self.navigationItem.title = memoListViewNavigationBarTitle
        self.navigationItem.rightBarButtonItem = plusMemo
    }
    
    private func configurefirstMemo() {
        memoDetailViewDelegate?.configureDetailText(data: memoListViewModel.readMemo(index: 0))
    }
 
    private func tableViewAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memoListViewModel.countMemo()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier) as? MemoListCell else {
            return UITableViewCell()
        }
        let memoData = memoListViewModel.readMemo(index: indexPath.row)
        cell.configureCell(memoData: memoData, stringLastModified: memoListViewModel.convertDate(date: memoData.lastModified))
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        memoDetailViewDelegate?.configureDetailText(data: memoListViewModel.readMemo(index: indexPath.row))
        guard let detail = memoDetailViewDelegate as? MemoDetailViewController else { return }
        showDetailViewController(UINavigationController(rootViewController: detail), sender: nil)
    }
        
}

extension MemoListViewController {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
//    
//    
//    
//    func getAllMemo() {
//        let data = context.fetch
//    }
//    
//    func createMemo(title: String, body: String) {
//        
//    }
//    
//    func deleteMemo(memo: MemoData) {
//        
//    }
//    
//    func updateMemo(memo: MemoData) {
//        
//    }
    
}
