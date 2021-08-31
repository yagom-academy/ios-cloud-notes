//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitView: UISplitViewController {
    
    let headerController = CategoryView()
    let contentsController = ContentsView()
    
    override var splitBehavior: UISplitViewController.SplitBehavior {
        return .displace
    }
    
    override var displayMode: UISplitViewController.DisplayMode {
        return .oneOverSecondary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange

        setViewController(ContentsView(), for: .secondary)
        setViewController(CategoryView(), for: .primary)
        
        
        let asset = NSDataAsset(name: "sampleData")
        
        let json = try! JSONSerialization.jsonObject(with: asset!.data, options: JSONSerialization.ReadingOptions()) as! [[String: Any]]
        
        let memos: [Memo] = json.map {
            let title = $0["title"] as? String
            let description = $0["body"] as? String
            let lastUpdatedTime = $0["last_modified"] as? Double
            let date = Date(timeIntervalSince1970: lastUpdatedTime!)
            
            let memo =  Memo(title: title!, description: description!, lastUpdatedTime: date)
            
            return memo
        }
        
        let list = MemoList(memo: memos)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if isCollapsed {
//            show(.primary)
//        }
    }
}
