//
//  CloudNotes - MemoListVC.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MemoListVC: UIViewController {
    var splitView: SplitVC?
    var memoModel: MemoListVCModel = MemoListVCModel()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private let plusMemo = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ConfigureMemoListView()
        tableViewAutoLayout()
        
    }
    
    private func ConfigureMemoListView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.memoModel.loadSampleData()
        
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.backgroundColor = .white
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = plusMemo
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

extension MemoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memoModel.countMemo()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier) as? MemoListCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(data: memoModel.readMemo(index: indexPath.row))
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailView: DetailMemoVC = splitView?.detail as? DetailMemoVC else {
            return
        }
        
        if UITraitCollection.current.horizontalSizeClass == .compact {
            let navigationVC = UINavigationController(rootViewController: detailView)
            showDetailViewController(navigationVC, sender: self)
        }
        
        detailView.configureDetail(data: memoModel.readMemo(index: indexPath.row))
    }
    
    
}

