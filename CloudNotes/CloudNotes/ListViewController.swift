//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ListViewController: UIViewController {
    let tableView = UITableView()
    let contentViewController = ContentViewController()
    var delegate: SendingDataDelegate?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           if let selectedIndexPath = tableView.indexPathForSelectedRow {
               tableView.deselectRow(at: selectedIndexPath, animated: animated)
           }
    }
    
    private func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.addSubview(tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
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
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = memoList[indexPath.row].title
        cell.predescriptionLabel.text = memoList[indexPath.row].body
        cell.dateLabel.text = memoList[indexPath.row].lastModified.convertToDate()
        return cell
    }
}
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memoList[indexPath.row]
        self.delegate = contentViewController
        delegate?.matchData(with: selectedMemo)
        self.navigationController?.pushViewController(contentViewController, animated: true)
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
