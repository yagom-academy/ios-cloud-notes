//
//  ListTableViewController.swift
//  CloudNotes
//
//  Created by steven on 2021/05/31.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var memoList: [Memo] = []
    var lastClickedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        parseSampleData()
        memoList = CoreDataManager.shared.fetchMemos()
        setNavigationItem()
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.tableView.estimatedRowHeight = 90.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController,
           let textViewController = detailNavigationController.topViewController as? TextViewController {
            // TODO: - 메모에 아무것도 없을 때도 처리해줘야 함.
            // 시작 했을 때 아무것도 없으면 메모가 삭제됨 그래서 점을 넣음.
            textViewController.textView.text = "."
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        } else {
            print("텍스트튜 없음")
        }
    }
    
    func parseSampleData() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let jsonData = NSDataAsset(name: "sample") else {
            return
        }
//        guard let memoList = try? jsonDecoder.decode([Memo].self, from: jsonData.data) else {
//            return
//        }
//        self.memoList = memoList
    }
    
    func setNavigationItem() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTouched(_:)))
    }
     
    @objc func addBarButtonTouched(_ sender: UIBarButtonItem) {
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController,
           let textViewController = detailNavigationController.topViewController as? TextViewController {
            textViewController.textView.text = ""
            tableView.beginUpdates()
            memoList.insert(CoreDataManager.shared.makeNewMeno(), at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            tableView.endUpdates()
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
            textViewController.changedTextBySelectedCell(with: memoList[0])
            lastClickedIndexPath = IndexPath(row: 0, section: 0)
        } else {
            let navigationEmbeddTextViewController = UINavigationController(rootViewController: TextViewController())
            self.splitViewController?.showDetailViewController(navigationEmbeddTextViewController, sender: nil)
        }
    }
    
}

extension ListTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let memoItem = memoList[indexPath.row]
        cell.titleLabel.text = memoItem.title ?? "새로운 메모"
        cell.dateLabel.text = memoItem.lastModified?.formatDate()
        cell.bodyLabel.text = memoItem.body ?? "추가 텍스트 없음"
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.systemYellow
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController,
           let textViewController = detailNavigationController.topViewController as? TextViewController {
            textViewController.textView.isEditable = false
            print("마지막 textView = ", textViewController.textView.text)
            print("최신 indexPath = ", indexPath)
            // 클릭 되기전 마지막 텍스트뷰가 아무것도 없으면
            if textViewController.textView.text.isEmpty && lastClickedIndexPath != indexPath {
                // 메모 리스트에서 지운다.
                print("들어옴!!")
                memoList.remove(at: lastClickedIndexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [lastClickedIndexPath], with: .automatic)
                tableView.endUpdates()
                // 여기서 -1을 하는 이유는 최상단의 빈 메모가 지워졌기 때문
                textViewController.changedTextBySelectedCell(with: memoList[indexPath.row - 1])
            } else {
                textViewController.changedTextBySelectedCell(with: memoList[indexPath.row])
            }
            textViewController.textView.isEditable = true
            lastClickedIndexPath = indexPath
        } else {
            let textViewController = TextViewController()
            let navigationController = UINavigationController(rootViewController: textViewController)
            self.splitViewController?.showDetailViewController(navigationController, sender: nil)
            textViewController.changedTextBySelectedCell(with: memoList[indexPath.row])
        }
    }
    
}

extension Date {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
}


