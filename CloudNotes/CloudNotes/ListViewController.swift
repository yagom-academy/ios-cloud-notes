//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ListViewController: UITableViewController {
    lazy var addMemoButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()

    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var memoList = [Memo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMemo()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = memoList[indexPath.row].title
        cell.predescriptionLabel.text = memoList[indexPath.row].body
        cell.dateLabel.text = memoList[indexPath.row].lastModified?.convertToDate()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        enterContentVC(indexPath: indexPath)
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

    @objc private func addButtonTapped(_ sender: Any) {
        guard let context = self.context else { return }
        let newMemo = Memo(context: context)
        newMemo.title = "새로운 메모"
        newMemo.body = "추가 텍스트 없음"
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
        enterContentVC(indexPath: nil)
    }

    private func enterContentVC(indexPath: IndexPath?) {
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

    //MARK: Load from core data...
    private func fetchMemo() {
        guard let context = self.context else { return }
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
}

extension Date {
    func convertToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
}
