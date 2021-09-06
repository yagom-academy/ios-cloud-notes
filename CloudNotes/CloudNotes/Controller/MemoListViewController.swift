//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoListViewController: UIViewController {
    private let navigationTitle = "메모"
    private var memoList: [Memo] = []
    private let parsingManager = ParsingManager()
    let memoListTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navigationTitle
        view.addSubview(memoListTableView)
        setLayoutForTableView()
        memoListTableView.dataSource = self
        fetchDataToMemoList(by: "sample")
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
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
