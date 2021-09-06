//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewController: UITableViewController {
    
    // MARK: - Properties
    var mockItems: [Savable] = [MockModel(), MockModel(), MockModel(),]
    var memos: [Savable]?
    let isCompact: Bool
    
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
        
        memos = decodeData()
        
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: nil)
        
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func decodeData() -> [Savable]? {
        let decoder = JSONDecoder()
        let memoDataIdentifier = "sample"
        
        guard let dataAsset = NSDataAsset(name: memoDataIdentifier) else {
            return nil
        }
        
        if let memos = try? decoder.decode([Memo].self, from: dataAsset.data) {
            return memos
        }
        return nil
    }
}

// MARK: - Table view data source
extension MemoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let memos = memos else {
            return 1
        }
        return memos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "MemoTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            as? MemoTableViewCell{
            
            guard let memos = memos else {
                return UITableViewCell()
            }
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
            guard let memos = memos else {
                return
            }
            detailViewController.configure(with: memos[indexPath.row])
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            guard let memos = memos else {
                return
            }
            detailViewController.configure(with: memos[indexPath.row])
            let navigation = UINavigationController(rootViewController: detailViewController)
            self.showDetailViewController(navigation, sender: self)
        }
    }
}
