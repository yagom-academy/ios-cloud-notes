//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class MemoSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setSplitView()
    }
    
    private func setSplitView() {
        let memoListViewController = MemoListViewController()
        let detailViewController = DetailViewController()
        memoListViewController.title = "메모"
        memoListViewController.delegate = detailViewController
    
        let memoListViewNavigationController = UINavigationController(rootViewController: memoListViewController)
        let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)
        self.preferredDisplayMode = .oneBesideSecondary
        self.viewControllers = [memoListViewNavigationController, detailViewNavigationController]
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
