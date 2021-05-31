//
//  CloudNotes - MemoListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewSetting()
        navigationItemSetting()
    }
    
    func viewSetting() {
        self.view.backgroundColor = .white
    }
    
    func navigationItemSetting() {
        self.navigationItem.title = "메모"
    }


}

