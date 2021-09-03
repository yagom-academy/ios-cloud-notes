//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

protocol SelectedCellDelegate: AnyObject {
    func showSelectedDetail(memo: Memo, index: Int?)
}

class PrimaryViewController: UITableViewController {
        
    var primaryTableViewDataSource: PrimaryTableViewDataSource?
    weak var delegate: SelectedCellDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "메모"
        
        primaryTableViewDataSource = PrimaryTableViewDataSource(showDetailAction: { seleted, index in
            self.delegate?.showSelectedDetail(memo: seleted, index: index)
        })
        tableView.dataSource = primaryTableViewDataSource
        tableView.delegate = primaryTableViewDataSource
        tableView.register(PrimaryTableViewCell.self, forCellReuseIdentifier: PrimaryTableViewCell.reuseIdentifier)
    }
}
