//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitView: UISplitViewController {
    
    let itemListView = ItemListView()
    let itemDetailView = ItemDetailView()
    let splitViewDelegate = SplitViewDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = splitViewDelegate
        
        view.backgroundColor = .orange
        
        setViewController(itemListView, for: .primary)
        setViewController(itemDetailView, for: .secondary)
    }
}
