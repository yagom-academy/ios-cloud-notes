//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoListViewController: UIViewController {
    private let navigationTitle = "메모"
    private let sampleAsset = "sample"
    private let lineBreak = "\n\n"

    private var memoList: [Memo] = []
    private let parsingManager = ParsingManager()
    let memoListTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memoListTableView)
        makeNavigationItem()
        fetchDataToMemoList(by: sampleAsset)
        setLayoutForTableView()
        memoListTableView.dataSource = self
        memoListTableView.delegate = self
        memoListTableView.register(MemoCustomCell.classForCoder(), forCellReuseIdentifier: MemoCustomCell.cellIdentifier)
    }
    
    private func makeNavigationItem() {
        self.navigationItem.title = navigationTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpPlusButton))
    }
    
    @objc private func touchUpPlusButton() {
    }
    
    private func setLayoutForTableView() {
        memoListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     memoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     memoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchDataToMemoList(by asset: String) {
        let parsedData = parsingManager.decode(from: asset, to: [Memo].self)
        switch parsedData {
        case .success(let result):
            memoList.append(contentsOf: result)
        case .failure(let error):
            break
        }
    }
    
    private func convertDataFormat(of date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: MemoCustomCell.cellIdentifier, for: indexPath) as? MemoCustomCell else {
            return UITableViewCell()
        }
        let currentMemo = memoList[indexPath.row]
        customCell.configureContent(from: currentMemo, with: convertDataFormat(of: currentMemo.lastModified))
        return customCell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = splitViewController?.viewController(for: .secondary) as? MemoDetailViewController else { return }
        detailVC.memoDeatailTextView.text = memoList[indexPath.row].title + lineBreak + memoList[indexPath.row].body
        splitViewController?.show(.secondary)
    }
}
