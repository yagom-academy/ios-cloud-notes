//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

protocol SelectedCellDelegate: AnyObject {
    func showSelectedDetail(_ memo: Memo, isSelected: Bool)
}

class PrimaryViewController: UITableViewController {
    weak var delegate: SelectedCellDelegate?
    private var primaryTableViewDataSource: PrimaryTableViewDataSource?
    private var selectedIndexPath: IndexPath?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.title = "메모"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryTableViewDataSource = PrimaryTableViewDataSource(showDetailAction: { seletedMemo, indexPath, check in
            self.delegate?.showSelectedDetail(seletedMemo, isSelected: check)
            self.selectedIndexPath = indexPath
        })
        tableView.dataSource = primaryTableViewDataSource
        tableView.delegate = primaryTableViewDataSource
        tableView.register(PrimaryTableViewCell.self, forCellReuseIdentifier: PrimaryTableViewCell.reuseIdentifier)
    }
}

extension PrimaryViewController {
    func updateSecondaryChanging(by memo: Memo) {
        guard let indexPath = selectedIndexPath else {
            print("에러처리 필요 - 선택된 인덱스 없음")
            return
        }
        primaryTableViewDataSource?.update(memo, indexPath) {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
