//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CloudNoteSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let listView = ListViewController()
        let memoView = MemoViewController()
        self.viewControllers = [listView, memoView]
    }
}
