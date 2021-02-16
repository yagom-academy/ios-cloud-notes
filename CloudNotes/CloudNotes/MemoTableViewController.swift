//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

class MemoTableViewController: UIViewController {
    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var memoModel: [Memo]?
    var memoViewControllerDelegate: MemoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoModel = MemoModel.getData()
        configureTableView()
    }
}

//MARK: - TableView
extension MemoTableViewController {
    func configureTableView() {
        memoListTableView.delegate = self
        memoListTableView.dataSource = self
        memoListTableView.frame = view.frame
        view.addSubview(memoListTableView)
        configureConstraints()
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MemoTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: memoModel?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoModel = self.memoModel else {
            return
        }
        let memo = memoModel[indexPath.row].body
        if self.splitViewController?.traitCollection.horizontalSizeClass == .compact {
            let memoViewController = memoViewControllerDelegate!.getMemoViewController()
            self.splitViewController?.showDetailViewController(memoViewController, sender: nil)
        }
        memoViewControllerDelegate?.setMemo(memo)
    }
}
