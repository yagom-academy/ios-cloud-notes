//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class MemoListViewController: UIViewController {
    
    let memoTableView = UITableView()
    var delegate: SendDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoTableView.dataSource = self
        self.memoTableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.memoTableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.addSubview(self.memoTableView)
        setTableViewConstraint()
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: NSNotification.Name("didRecieveNotification"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if splitViewController?.traitCollection.horizontalSizeClass == .regular {
            delegate?.isRegularTextViewColor(regular: true)
        }
        
        DataManager.shared.fetchData()
        self.memoTableView.reloadData()
    }
    
    @objc func didRecieveNotification(_ notification: Notification) {
        memoTableView.reloadData()
        
        guard let receiveData = notification.userInfo else { return }
        
        guard let receiveText: String = receiveData["textViewText"] as? String else { return }
        guard let currentIndex: Int = receiveData["currentIndex"] as? Int else { return }
   
        let splitText = receiveText.split(separator: "\n",maxSplits: 1).map { (value) -> String in
            return String(value) }
        
        DataManager.shared.memoList[currentIndex].title = splitText.first ?? ""
        if splitText.first != splitText.last {
            DataManager.shared.memoList[currentIndex].body = splitText.last ?? ""
        }
        
        DataManager.shared.saveContext()
        DataManager.shared.fetchData()
        

    }
    
    @objc func addNote() {
        DataManager.shared.createData()
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
    
}

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.sendData(data: DataManager.shared.memoList[indexPath.row], index: indexPath.row)
        
        if UITraitCollection.current.horizontalSizeClass == .compact {
            splitViewController?.show(.secondary)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler ) in
            
            let defaultAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                DataManager.shared.deleteData(index: indexPath.row)
                self.memoTableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true)
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "공유") { (action, view, completionHandler ) in
            let sendText = DataManager.shared.memoList[indexPath.row].body
            
            let shareSheetViewController = UIActivityViewController(activityItems: [sendText], applicationActivities: nil)
        
            if let popOverController = shareSheetViewController.popoverPresentationController {
                popOverController.sourceView = view
            }
            
            self.present(shareSheetViewController, animated: true)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
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
