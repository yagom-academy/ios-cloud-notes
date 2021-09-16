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
    private var memoList = CoreDataManager.shared.memoList
    private let parsingManager = ParsingManager()
    private let dateFormattingManager = DateFormattingManager()
    private let memoListTableView = UITableView()
    private var selectedIndexPath: IndexPath?
    var delegate: MemoEntitySendable?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
        setTableViewToMemoListVC()
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
    //TODO: - show memoDetailTextView when it`s touched
    @objc private func touchUpPlusButton() {
        CoreDataManager.shared.addNewMemo(title: "새로운 메모입니다.", body: "데이터를 입력해주세요", lastModifiedDate: Date())
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
        guard let indexPath = selectedIndexPath else { return }
        memoList[indexPath.row] = memo
        guard let customCell = memoListTableView.dequeueReusableCell(withIdentifier: MemoCustomCell.cellIdentifier, for: indexPath) as? MemoCustomCell else {
            return
        }
        customCell.configureContent(from: memo, with: dateFormattingManager.convertDoubleTypeToDate(of: memo.lastModifiedDate))
        memoListTableView.reloadRows(at: [indexPath], with: .none)
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
}
