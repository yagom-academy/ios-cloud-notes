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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MemoListViewConfigure()
        tableViewAutoLayout()
        
        memoModel.loadSampleData()
    }
    
    func MemoListViewConfigure() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.backgroundColor = .white
        self.navigationItem.title = "메모"
    }
 
    func tableViewAutoLayout() {
        let guide = view.safeAreaLayoutGuide
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
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
        
        self.navigationController?.pushViewController(detailView, animated: false)
        
        detailView.configureDetail(data: memoModel.readMemo(index: indexPath.row))
    }
    
    
}

