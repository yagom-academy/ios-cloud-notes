//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListViewController: UIViewController{
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        configureTableView()
        ConfigureAutoLayout()
    }
    
    private func ConfigureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = self
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = "제목인데 조금 길면 어떻게 나오는지 한번 봐야할듯"
        cell.dateLabel.text = "2021.10.21."
        cell.shortDiscriptionLabel.text = "아니 근데 진짜 코드로 ui 만드는거 언제 익숙해지지 진짜 이거 빨리 익혀야 좀 편하게 할텐데 오토레이아웃 잡을때마다 진짜 개빡침 오토레이아웃 공부 빨리 제대로 해야지 이거 우선도랑 CRCH도 어떻게 하는지 알아야하고 스택뷰도 잘 다뤄야지 얼른 하자 진짜"
        
        return cell
    }
}

