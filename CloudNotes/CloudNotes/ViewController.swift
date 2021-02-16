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
}
