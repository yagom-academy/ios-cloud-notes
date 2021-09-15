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
        let primaryViewController = MemoListViewController()
        let secondaryViewController = MemoDetailViewController()
        
        let primaryNavigationController = UINavigationController(rootViewController: primaryViewController)
        let secondaryNavigationController = UINavigationController(rootViewController: secondaryViewController)
        
        primaryNavigationController.navigationBar.topItem?.title = "메모"
        primaryNavigationController.navigationBar.topItem?.rightBarButtonItem =  UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addMemoAction))
        viewControllers = [primaryNavigationController, secondaryNavigationController]
        self.preferredDisplayMode = .oneBesideSecondary
        self.delegate = self
        
        primaryViewController.splitViewDelegate = self
    }
}

extension CloudMemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        return true
    }
}

extension CloudMemoSplitViewController {
    @objc
    func addMemoAction() {

    }
}

extension CloudMemoSplitViewController: CustomSplitViewDelegate {
    func showDetailViewController(_ memo: MemoEntity) {
        guard let primaryNavigationController = viewControllers.first else {
            return
        }
        
        let memoDetailViewController = MemoDetailViewController(memo: memo)
        let secondaryNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        primaryNavigationController.showDetailViewController(secondaryNavigationController, sender: self)
    }
}
