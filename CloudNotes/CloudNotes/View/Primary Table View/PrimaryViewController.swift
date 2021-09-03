//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryViewController: UITableViewController {
    
    typealias ShowDetailAction = (Memo) -> Void
    
    var primaryTableViewDataSource: PrimaryTableViewDataSource?
    private var showDetailAction: ShowDetailAction?
    
    init(showDetailAction: @escaping ShowDetailAction) {
        super.init(nibName: nil, bundle: nil)
        self.showDetailAction = showDetailAction
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "메모"
        
        primaryTableViewDataSource = PrimaryTableViewDataSource(showDetailAction: { seleted in
            self.showDetailAction?(seleted)
        })
        tableView.dataSource = primaryTableViewDataSource
        tableView.delegate = primaryTableViewDataSource
        tableView.register(PrimaryTableViewCell.self, forCellReuseIdentifier: PrimaryTableViewCell.reuseIdentifier)
        
    }
}
