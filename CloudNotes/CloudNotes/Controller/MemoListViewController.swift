//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/03.
//

import UIKit

class MemoListViewController: UIViewController {
    private let listTableView = UITableView()
    private var memoList = [Memo]()
    private var selectedIndexPath: IndexPath?
    weak var cellSelectionDelegate: CellSellectionHandleable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewConstraints()
        registerTableViewCell()
        setUpNavigationTitle()
        setUpNavigationItem()
        listTableView.dataSource = self
        listTableView.delegate = self
    }
}

//MARK:- Set up TableView
extension MemoListViewController {
    private func setUpTableViewConstraints() {
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        
        listTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        listTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        listTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    private func registerTableViewCell() {
        listTableView.register(MemoItemTableViewCell.self, forCellReuseIdentifier: MemoItemTableViewCell.identifier)
    }
}

//MARK:- Set up NavigationBar
extension MemoListViewController {
    private func setUpNavigationTitle() {
        let title = "메모"
        navigationItem.title = title
        navigationItem.backButtonTitle = title
    }
    
    private func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
    }
}

//MARK:- configure memoList
extension MemoListViewController {
    func setUpList(with newList: [Memo]) {
        memoList = newList
        reloadAllTableViewData()
    }
    
    func reflectChange(with memoItem: Memo) {
        guard let selectedIndexPath = selectedIndexPath else {
            return
        }
        memoList[selectedIndexPath.row] = memoItem
        reloadTableViewData(at: selectedIndexPath)
    }
}

//MARK:- Update TableView
extension MemoListViewController {
    private func reloadAllTableViewData() {
        listTableView.reloadData()
    }
    
    private func reloadTableViewData(at indexPath: IndexPath) {
        listTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK:- Conform to TableViewDataSource
extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoItemTableViewCell.identifier, for: indexPath)
                as? MemoItemTableViewCell else {
            return MemoItemTableViewCell()
        }
        cell.configure(with: memoList[indexPath.row])
        return cell
    }
}

//MARK:- Conform to TableViewDelegate
extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelectionDelegate?.handOver(data: memoList[indexPath.row])
        selectedIndexPath = indexPath
    }
}
