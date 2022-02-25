//
//  MemoSearchResultTableViewController.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/25.
//

import UIKit

class MemoSearchResultTableViewController: UITableViewController {
    var selectedMemoId: UUID?
    private var searchedMemos = [Memo]() {
        didSet {
            searchedMemos.sort { $0.lastModified > $1.lastModified }
        }
    }
    
    private let searchResultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음".localized
        label.textColor = .placeholderText
        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellWithClass: MemoTableViewCell.self)
        configureSearchResultLabel()
    }
    
    func configureSearchResultLabel() {
        let backgroundView = UIView()
        backgroundView.addSubview(searchResultLabel)
        
        NSLayoutConstraint.activate([
            searchResultLabel.centerXAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerXAnchor),
            searchResultLabel.centerYAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        tableView.backgroundView = backgroundView
    }
    
    func fetch(at indexPath: IndexPath) -> Memo {
        return searchedMemos[indexPath.row]
    }
    
    func updateSearchResult(with memos: [Memo]) {
        searchedMemos = memos
        tableView.reloadData()
    }
    
    func changeStateOfSearchResultLabel(hidden: Bool) {
        searchResultLabel.isHidden = hidden
    }
}

// MARK: - UITableViewDataSource

extension MemoSearchResultTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMemos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MemoTableViewCell.self, for: indexPath)
        
        let data = searchedMemos[indexPath.row]
        cell.configureCellContent(from: data)
        
        return cell
    }
}
