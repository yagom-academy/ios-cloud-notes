//
//  MenuTableViewController.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var memoList = [Memo]()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        title = "메모"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MemoListCell.self,
                           forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeTest() {
        guard let assetData = NSDataAsset.init(name: "sample") else { return }
        guard let memoData = ParsingManager.decodingModel(data: assetData.data, model: [Memo].self) else {
            return
        }
        memoList = memoData
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = memoList[indexPath.row].title
        cell.dateLabel.text = dateFormatter.string(from: memoList[indexPath.row].lastModifiedDate)
        cell.descriptionLabel.text = memoList[indexPath.row].description
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
