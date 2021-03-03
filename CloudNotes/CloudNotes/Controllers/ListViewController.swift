//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol MemoStatusDelegate {
    func updateMemo(memo: Memo)
    func deleteMemo(memo: Memo)
}

class ListViewController: UITableViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var memoList = [Memo]()
    private lazy var addMemoButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNavigationBar()
        fetchMemo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        
        if memoList[indexPath.row].title == " ",
           memoList[indexPath.row].body == " " {
            cell.titleLabel.text = "새로운 메모"
            cell.predescriptionLabel.text = "추가 텍스트 없음"
        } else {
            cell.titleLabel.text = memoList[indexPath.row].title
            cell.predescriptionLabel.text = memoList[indexPath.row].body
        }
        
        cell.dateLabel.text = memoList[indexPath.row].lastModified?.convertToDate()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showContentViewController(indexPath: indexPath)
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        createNewMemo()
        showContentViewController(indexPath: nil)
    }
}
extension ListViewController {
    //MARK: CREATE
    private func createNewMemo() {
        let newMemo = Memo(context: context)
        newMemo.title = " "
        newMemo.body = " "
        newMemo.lastModified = Date()
        
        do {
            try context.save()
            fetchMemo()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch(let error) {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    //MARK: READ
    private func fetchMemo() {
        do {
            memoList = try context.fetch(Memo.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch(let error) {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    //MARK: UPDATE
    private func updateItem(_ memo: Memo) { // title, body, date 변경 모두 포함된 메모
        do {
            try context.save() // 데이터 반영
            fetchMemo()
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
        
    }
    
    //MARK: DELETE
    private func deleteItem(memo: Memo) {
        context.delete(memo)
        do {
            try context.save()
            fetchMemo()
        } catch {
            
        }
    }
}

extension ListViewController {
    private func setUpTableView() {
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = addMemoButton
    }
    
    private func showContentViewController(indexPath: IndexPath?) {
        let contentVC = ContentViewController()
        if indexPath != nil {
            contentVC.didTapMemoItem(with: memoList[indexPath!.row])
        } else {
            guard let recentlyCreatedMemo = memoList.last else { return }
            contentVC.didTapMemoItem(with: recentlyCreatedMemo)
        }
        splitViewController?.viewControllers.append(UINavigationController())
        (splitViewController?.viewControllers.last as? UINavigationController)?.pushViewController(contentVC, animated: true)
    }
}
extension ListViewController: MemoStatusDelegate {
    func updateMemo(memo: Memo) {
        self.updateItem(memo)
    }

    func deleteMemo(memo: Memo) {
        self.deleteItem(memo: memo)
    }
}
