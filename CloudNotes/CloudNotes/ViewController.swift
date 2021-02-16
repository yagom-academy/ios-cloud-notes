//
//  CloudNotes - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UITableViewController {
    private var memoList: [Memo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeMemoData()
        setUpNavigationBar()
    }
    
    private func decodeMemoData() {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "sample") else {
            return
        }
        do {
            self.memoList = try JSONDecoder().decode([Memo].self, from: dataAsset.data)
        } catch {
            print(error)
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(moveToPostViewController))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    
    @objc private func moveToPostViewController() {
        //📍 CRUD Create 부분
    }
}
