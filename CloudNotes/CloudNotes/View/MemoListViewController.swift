//
//  CloudNotes - MemoListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MemoListViewController: UIViewController {
    private var memoListViewModel: MemoListViewModel = MemoListViewModel()
    private let memoListViewNavigationBarTitle: String = "메모"
    private var memoDetailViewDelegate: MemoDetailViewDelegate?
    private var tableView: UITableView = UITableView()

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
        tableViewAutoLayout()
        addNotifictaionObserver()
    }
    
    private func reloadTableView() {
        self.tableView.reloadData()
    }
    
    private func configureMemoListView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.backgroundColor = .white
        self.navigationItem.title = memoListViewNavigationBarTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(didTapAdd))
    }
    
    private func addNotifictaionObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteMemo),
                                               name: NotificationNames.delete.name,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateMemo(notification:)),
                                               name: NotificationNames.update.name,
                                               object: nil)
    }
    
    @objc private func didTapAdd() {
        memoListViewModel.coreDataMemoModel.createMemoData()
        memoListViewModel.getAllMemoData()
        if UITraitCollection.current.horizontalSizeClass == .compact {
            memoDetailViewDelegate?.setupDetailText(data: memoListViewModel.readMemo(index: 0))
            guard let detail = memoDetailViewDelegate as? MemoDetailViewController else { return }
            self.navigationController?.pushViewController(detail, animated: true)
        } else {
            reloadTableView()
        }
    }
    
    @objc private func deleteMemo() {
        guard let memoData = self.memoListViewModel.editingMemo else { return }
        self.memoListViewModel.coreDataMemoModel.deleteMemoData(data: memoData)
        self.memoListViewModel.getAllMemoData()
        reloadTableView()
    }
    
    @objc private func updateMemo(notification: Notification) {
        guard let textData: String = notification.object as? String else { return }
        guard let memoData = self.memoListViewModel.editingMemo else { return }
        let subString = textData.subString(target: textData, point: "\n")
        if subString.count == 2 {
            self.memoListViewModel.coreDataMemoModel.updateMemoData(titleText: subString[0],
                                                  bodyText: subString[1],
                                                  data: memoData)
        } else {
            self.memoListViewModel.coreDataMemoModel.updateMemoData(titleText: textData, bodyText: "", data: memoData)
        }
        reloadTableView()
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
        cell.configureCell(memoData: memoData,
                           stringLastModified: memoListViewModel.coreDataMemoModel.converter.convertDate(date: memoData.lastModified))
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo: MemoData = memoListViewModel.readMemo(index: indexPath.row)
        self.memoListViewModel.setupEditingMemo(index: indexPath.row)
        memoDetailViewDelegate?.setupDetailText(data: memo)
        guard let detail = memoDetailViewDelegate as? MemoDetailViewController else { return }
        
        if splitViewController?.traitCollection.horizontalSizeClass == .compact {
            self.navigationController?.pushViewController(detail, animated: true)
        } else {
            showDetailViewController(UINavigationController(rootViewController: detail), sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.memoListViewModel.setupEditingMemo(index: indexPath.row)
        let delete = UIContextualAction(style: .normal,
                                        title: "delete",
                                        handler: {(action, view, completionHandler) in
            self.deleteMemo()
            completionHandler(true)
        })
        let share = UIContextualAction(style: .normal,
                                       title: "share",
                                       handler: {(action, view, completionHandler) in
            let text = self.memoListViewModel.memoDataText(data: self.memoListViewModel.readMemo(index: indexPath.row))
            let activityController = UIActivityViewController(activityItems: [text],
                                                              applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        })
        delete.backgroundColor = .systemRed
        share.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [share, delete])
    }
        
}
