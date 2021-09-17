//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoListViewController: UIViewController {
    private let navigationTitle = "메모"
    private let sampleAsset = "sample"
    private var memoList: [MemoEntity] {
        CoreDataManager.shared.memoList
    }
    private let parsingManager = ParsingManager()
    private let dateFormattingManager = DateFormattingManager()
    private let memoListTableView = UITableView()
    private var selectedIndexPath: IndexPath?
    var delegate: MemoEntitySendable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
        setTableViewToMemoListVC()
        CoreDataManager.shared.fetchMemo()
    }
    
    private func makeNavigationItem() {
        navigationItem.title = navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpPlusButton))
    }
    
    private func setTableViewToMemoListVC() {
        view.addSubview(memoListTableView)
        memoListTableView.dataSource = self
        memoListTableView.delegate = self
        memoListTableView.register(MemoCustomCell.classForCoder(), forCellReuseIdentifier: MemoCustomCell.cellIdentifier)
        setLayoutForTableView()
    }
    
    @objc private func touchUpPlusButton() {
        CoreDataManager.shared.addNewMemo(title: PlaceHolder.title, body: PlaceHolder.body, lastModifiedDate: Date())
        selectedIndexPath = IndexPath(row: 0, section: 0)
        CoreDataManager.shared.fetchMemo()
        delegate?.didSelectRow(at: memoList[.zero])
        memoListTableView.reloadData()
    }
    
    private func setLayoutForTableView() {
        memoListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     memoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     memoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureModifiedCell(by memo: MemoEntity) {
        guard let indexPath = selectedIndexPath else {
            return
        }
        CoreDataManager.shared.update(memo: memo, with: indexPath)
        guard let customCell = memoListTableView.dequeueReusableCell(withIdentifier: MemoCustomCell.cellIdentifier, for: indexPath) as? MemoCustomCell else {
            return
        }
        customCell.configureContent(from: memo, with: dateFormattingManager.convertDoubleTypeToDate(of: memo.lastModifiedDate))
        memoListTableView.reloadData()
        CoreDataManager.shared.fetchMemo()
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: MemoCustomCell.cellIdentifier, for: indexPath) as? MemoCustomCell else {
            return UITableViewCell()
        }
        let currentMemo = memoList[indexPath.row]
        customCell.configureContent(from: currentMemo, with: dateFormattingManager.convertDoubleTypeToDate(of: currentMemo.lastModifiedDate))
        return customCell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        delegate?.didSelectRow(at : memoList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "삭제") { [weak self] (action, view, completionHandler) in
            print("삭제")
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        let shareAction = UIContextualAction(style: .normal,
                                             title: "공유") { [weak self] (action, view, completionHandler) in
            print("공유")
            completionHandler(true)
        }
        shareAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
