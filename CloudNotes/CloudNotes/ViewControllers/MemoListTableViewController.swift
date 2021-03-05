//
//  MemoListTableViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit
//import SwiftyDropbox

class MemoListTableViewController: UITableViewController {
    weak var delegate: MemoListSelectDelegate?
    var dropboxController = DropboxController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropboxController.delegate = self
        
        setupNavigationBar()
        setupTableView()
        fetchMemo()
        dropboxController.authorize(self)
        dropboxController.DownloadBackupMemoData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    }
    
    private func setupTableView() {
        self.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "memoCell")
    }
    
    @objc func addMemo() {
        /*
         * 가로 모드에서 메모 추가 버튼 클릭시
         * textView가 비어 있는지 확인 필요
         * 비어 있지 않다면 기존의 메모를 update한 후 빈 메모 추가
         * 비어 있따면 빈 메모 추가
         */
        guard let delegate = self.delegate else {
            return
        }
        if delegate.checkNotEmptyTextView() {
            delegate.memoUpdate()
        }
        saveMemo()
    }
    
    private func moveToMemoDetailViewController(with memoIndex: Int) {
        if let memoDetailViewController = delegate as? MemoDetailViewController,
           traitCollection.horizontalSizeClass == .compact {
            memoDetailViewController.index = memoIndex
            let memoDetailNavigationController = UINavigationController(rootViewController: memoDetailViewController)
            splitViewController?.showDetailViewController(memoDetailNavigationController, sender: nil)
        }
    }
    
    // MARK: MemoModel Method
    private func saveMemo() {
        do {
            try MemoModel.shared.save(title: nil, body: nil)
            // 빈 메모로 textView 변경
            moveToMemoDetailViewController(with: MemoModel.shared.list.startIndex)
            // 빈 메모 cell 추가
            insertFirstCell()
        } catch {
            showError(MemoError.saveMemo, okHandler: nil)
        }
    }
    
    private func fetchMemo() {
        do {
            try MemoModel.shared.fetch()
            self.tableView.reloadData()
            if !MemoModel.shared.list.isEmpty {
                self.delegate?.memoCellSelect(MemoModel.shared.list.startIndex)
            }
        } catch {
            self.showError(error, okHandler: nil)
        }
    }
}

extension MemoListTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoModel.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.setupMemoCell(with: MemoModel.shared.list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.memoCellSelect(indexPath.row)
        self.moveToMemoDetailViewController(with: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, _) in
            self.deleteMemoObject(with: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteMemoObject(with index: Int) {
        do {
            try MemoModel.shared.delete(index: index)
            self.deleteMemo(indexRow: index)
        } catch {
            self.showError(error, okHandler: nil)
        }
    }
}

extension MemoListTableViewController: MemoDetailDelegate {
    func insertNewMemo() {
        self.saveMemo()
        dropboxController.uploadBackupMemoData()
    }
    
    func insertFirstCell() {
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func deleteMemo(indexRow: Int) {
        self.tableView.deleteRows(at: [IndexPath(row: indexRow, section: 0)], with: .automatic)
        self.delegate?.memoCellDelete(indexRow)
        dropboxController.uploadBackupMemoData()
    }
    
    func updateMemo(indexRow: Int) {
        self.tableView.moveRow(at: IndexPath(row: indexRow, section: 0), to: IndexPath(row: 0, section: 0))
        self.tableView.reloadRows(at: [IndexPath(row: indexRow, section: 0), IndexPath(row: 0, section: 0)], with: .automatic)
        dropboxController.uploadBackupMemoData()
    }
    
    // 뭐지?
    func addEmptyMemo() {
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
    }
}

extension MemoListTableViewController: DownloadCompleteDelegate {
    func tableViewUpdate() {
        fetchMemo()
    }
}

protocol MemoListSelectDelegate: class {
    func memoCellSelect(_ index: Int?)
    func memoCellDelete(_ index: Int)
    func checkNotEmptyTextView() -> Bool
    func memoUpdate()
}
