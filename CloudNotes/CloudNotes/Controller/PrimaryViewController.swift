//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class PrimaryViewController: UIViewController {
    private let tableView = UITableView()
    private let tableViewDataSource = MainVCTableViewDataSource()
    private let navigationBarTitle = "메모"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = navigationBarTitle
        
        view.addSubview(tableView)
        tableView.dataSource = tableViewDataSource
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: CellId.defaultCell.description)
        tableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(didTabButton))
        
    }
    
    @objc func didTabButton() {
        let detailVC = SecondaryViewController()
        showDetailViewController(detailVC, sender: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension PrimaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if splitViewController?.isCollapsed == true {
            let secondVC = splitViewController?.viewController(for: .secondary) as? SecondaryViewController
            
            
            secondVC?.text = "\(MemoDataHolder.list?[indexPath.row].title)" + "\(MemoDataHolder.list?[indexPath.row].body)"
            splitViewController?.showDetailViewController(secondVC ?? SecondaryViewController(), sender: nil)
        } else {
            
            let naviVC = splitViewController?.viewControllers.last as? UINavigationController
            let secondVC = naviVC?.viewControllers.last as? SecondaryViewController
            

            secondVC?.textView.text = "\(MemoDataHolder.list?[indexPath.row].title)" + "\(MemoDataHolder.list?[indexPath.row].body)"
            splitViewController?.show(.primary)
        }
    }
}
