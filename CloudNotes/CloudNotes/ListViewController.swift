//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func didTapMemoItem(with memo: Memo)
}

class ListViewController: UITableViewController {
    weak var delegate: ListViewControllerDelegate?
    lazy var addMemoButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()
    private var memoList = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNavigationBar()
        decodeMemoList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = memoList[indexPath.row].title
        cell.predescriptionLabel.text = memoList[indexPath.row].body
        cell.dateLabel.text = memoList[indexPath.row].lastModified.convertToDate()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMemo = memoList[indexPath.row]
        delegate?.didTapMemoItem(with: selectedMemo)
    }
    
    private func setUpTableView() {
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = addMemoButton
    }
    
    private func decodeMemoList() {
        let assetFile: String = "sample"
        guard let asset = NSDataAsset(name: assetFile) else {
            fatalError("Can not found data asset.")
        }
        
        do {
            memoList = try JSONDecoder().decode([Memo].self, from: asset.data)
        } catch {
            print("error: \(error)")
        }
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}
extension Double {
    func convertToDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd."
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
}
