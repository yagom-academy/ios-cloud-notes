//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MenuViewController: UIViewController {
    var splitView: UISplitViewController?
    
    let tableView = UITableView()
    var data = [CloudNoteItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        data = ParsingManager().parse(fileName: "sample")
        configureTableView()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellIdentifier, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
