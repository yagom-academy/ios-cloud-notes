//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ContainerSplitViewController: UISplitViewController {
    private let columnStyle = UISplitViewController.Style.doubleColumn
    
    required init?(coder: NSCoder) {
        super.init(style: columnStyle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedViewControllers()
    }

}

//MARK:- Embed Inner ViewControllers
extension ContainerSplitViewController {
    private func embedViewControllers() {
        let primaryViewController = MemoListViewController()
        setViewController(primaryViewController, for: .primary)
        
        let secondaryViewController = MemoDetailViewController()
        setViewController(secondaryViewController, for: .secondary)
    }
}
