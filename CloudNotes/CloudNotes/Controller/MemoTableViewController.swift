//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewController: UITableViewController {
    
    // MARK: - Properties
    private let isCompact: Bool
    private var dataSource = MemoTableViewModel()
    fileprivate var memos = [Savable]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Initializer
    init(isCompact: Bool) {
        self.isCompact = isCompact
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: nil)
        
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.requestData()
    }
}

// MARK: - MemoTableViewModelDelegate
extension MemoTableViewController: MemoTableViewModelDelegate {
    func didUpdateData(data: [Savable]) {
        memos = data
    }
}

// MARK: - Table view data source
extension MemoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "MemoTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            as? MemoTableViewCell{
            cell.configureLabels(with: memos[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Table view delegate
extension MemoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = MemoDetailViewController()
        
        if self.isCompact {
            detailViewController.configure(with: memos[indexPath.row])
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            detailViewController.configure(with: memos[indexPath.row])
            let navigation = UINavigationController(rootViewController: detailViewController)
            self.showDetailViewController(navigation, sender: self)
        }
    }
}
