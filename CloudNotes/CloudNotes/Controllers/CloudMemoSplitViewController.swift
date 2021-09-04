//
//  CloudMemoSplitViewController.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/03.
//

import UIKit

class CloudMemoSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initContentHierarchy()
    }
    
    private func initContentHierarchy() {
        let primaryVC = MemoListViewController()
        let secondaryVC = MemoDetailViewController(memo: Memo.generateMemoList()[0])
        
        let primaryNav = UINavigationController(rootViewController: primaryVC)
        let secondaryNav = UINavigationController(rootViewController: secondaryVC)
        
        primaryNav.navigationBar.topItem?.title = "메모"
        viewControllers = [primaryNav, secondaryNav]
        
        self.preferredDisplayMode = .oneBesideSecondary
        self.delegate = self
    }
}

extension CloudMemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
