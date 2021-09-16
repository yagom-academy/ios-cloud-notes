//
//  CloudMemoSplitViewController.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/03.
//

import UIKit

class CloudMemoSplitViewController: UISplitViewController {
    let primaryViewController = MemoListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentHierarchy()
    }
    
    private func initContentHierarchy() {
        let secondaryViewController = MemoDetailViewController(isEditable: false)
        
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
        let memoDetailViewController = MemoDetailViewController()
        let secondaryNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        
        primaryViewController.showDetailViewController(secondaryNavigationController, sender: self)
    }
}

extension CloudMemoSplitViewController: CustomSplitViewDelegate {
    func showDetailViewController(_ memo: MemoEntity) {

        let memoDetailViewController = MemoDetailViewController(memo: memo)
        let secondaryNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        
        primaryViewController.showDetailViewController(secondaryNavigationController, sender: self)
    }
}
