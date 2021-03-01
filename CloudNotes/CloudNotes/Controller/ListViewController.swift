//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol SendMemoDelegate: AnyObject {
    func didTapListCell(memo: Memo?)
}

final class ListViewController: UIViewController {
    
    private var memoList: [Memo]?
    weak var delegate: SendMemoDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setTableView()
    }
    
    private func setNavigation() {
        self.title = "메모"
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goToAddMemoVeiwController))
    }
    
    @objc private func goToAddMemoVeiwController() {
       let addMemoViewController = AddMemoViewController()
        self.navigationController?.pushViewController(addMemoViewController, animated: false)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        memoList = Parser.decodeMemo()
        addSubview()
        setAutoLayout()
    }

    private func addSubview() {
        self.view.addSubview(tableView)
    }
    
    private func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let memoList = memoList else {
            return
        }
        let memo = memoList[indexPath.row]
        delegate?.didTapListCell(memo: memo)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let memoList = memoList else {
            return 0
        }
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        guard let memoList = memoList else {
            return UITableViewCell()
        }
        let memoListInfo = memoList[indexPath.row]
        cell.update(info: memoListInfo)
        return cell
    }
}
