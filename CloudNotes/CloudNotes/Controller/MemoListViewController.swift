//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class MemoListViewController: UIViewController {
    
    private let memoTableView = UITableView()
    private let decoder = JSONDecoder()
    var memoData: [MemoData] = []
    var delegate: SendDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoTableView.dataSource = self
        self.memoTableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.memoTableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.addSubview(self.memoTableView)
        setTableViewConstraint()
        decodeMemoData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if splitViewController?.traitCollection.horizontalSizeClass == .regular {
            delegate?.isRegularTextViewColor(regular: true)
        }
        
        DataManager.shared.fetchData()
        self.memoTableView.reloadData()
    }
    
    @objc func addNote() {
        let newMemo = Memo(context: DataManager.shared.mainContext)
        
        newMemo.title = "새메모"
        newMemo.body = "새바디"
        newMemo.lastModifiedDate = "날짜"
        
        DataManager.shared.saveContext()
        DataManager.shared.fetchData()
        self.memoTableView.reloadData()
    }
    
    private func setTableViewConstraint() {
        self.memoTableView.translatesAutoresizingMaskIntoConstraints = false
        self.memoTableView.rowHeight = 50
        self.view.addConstraint(NSLayoutConstraint(item: self.memoTableView,
                                                   attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,
                                                   multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.memoTableView,
                                                   attribute: .bottom, relatedBy: .equal, toItem: self.view,
                                                   attribute: .bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.memoTableView,
                                                   attribute: .leading, relatedBy: .equal, toItem: self.view,
                                                   attribute: .leading, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.memoTableView,
                                                   attribute: .trailing, relatedBy: .equal, toItem: self.view,
                                                   attribute: .trailing, multiplier: 1.0, constant: 0))
    }
    
    func decodeMemoData() {
        guard let data = NSDataAsset(name: "sample") else { return }
        
        do {
            self.memoData = try decoder.decode([MemoData].self, from: data.data)
        }
        catch {
            errorAlert(errorDescription: CloudNoteError.decode.localizedDescription)
        }
    }
    
    private func errorAlert(errorDescription: String) {
        let alert = UIAlertController(title: "경고", message: errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        splitViewController?.present(alert, animated: true, completion: nil)
    }
    
}

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendData(data: DataManager.shared.memoList[indexPath.row])
        
        guard let memoDetailViewController = delegate as? DetailViewController else { return }
        
        if UITraitCollection.current.horizontalSizeClass == .compact {
            splitViewController?.showDetailViewController(UINavigationController(rootViewController: memoDetailViewController) , sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler ) in
            let memoToRemove = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.mainContext.delete(memoToRemove)
            DataManager.shared.saveContext()
            DataManager.shared.fetchData()
            self.memoTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell
        let currentMemoData = DataManager.shared.memoList[indexPath.row]
        
        cell.setCellData(currentMemoData: currentMemoData)

        return cell
    }
    
}
