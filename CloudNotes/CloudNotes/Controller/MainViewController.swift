//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@IBDesignable
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainTableView)
        mainTableView.clipsToBounds = true
        mainTableView.directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        mainTableView.preservesSuperviewLayoutMargins = true
        mainTableView.directionalLayoutMargins = .zero
        
        //mainTableView.dataSource = self
    }
    
    let mainTableView = UITableView()
    //

}

//extension MainViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//
//}
