//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

class MemoSplitViewController: UISplitViewController {
    
    private let detailViewController = UINavigationController(rootViewController: MemoViewController())
    private let masterViewController = UINavigationController(rootViewController: MemoTableViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [masterViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewControllers.append(detailViewController)
    }
    
    func showMemoViewController(_ memo: Memo?) {
        guard let memoViewController = detailViewController.topViewController as? MemoViewController else {
            return
        }
        if let memo = memo {
            memoViewController.setMemo(memo)
        } else {
            
        }
        showDetailViewController(detailViewController, sender: nil)
    }
    
    func popMemoViewController() {
        masterViewController.popViewController(animated: true)
    }
}
