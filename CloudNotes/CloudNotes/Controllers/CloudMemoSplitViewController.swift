//
//  CloudMemoSplitViewController.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/03.
//

import UIKit

class CloudMemoSplitViewController: UISplitViewController {
    private let primaryViewController = MemoListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentHierarchy()
    }
    
    private func initContentHierarchy() {
        let guideSecondaryViewController = MemoDetailViewController(isEditable: false)
        
        let primaryNavigationController = UINavigationController(rootViewController: primaryViewController)
        let secondaryNavigationController = UINavigationController(rootViewController: guideSecondaryViewController)
        
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
    private func addMemoAction() {
        let memoDetailViewController = MemoDetailViewController()
        let secondaryNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        memoDetailViewController.listViewControllerDelegate = primaryViewController
        
        primaryViewController.showDetailViewController(secondaryNavigationController, sender: self)
    }
}

extension CloudMemoSplitViewController: CustomSplitViewDelegate {
    func showDetailViewController(_ memo: MemoEntity) {

        let memoDetailViewController = MemoDetailViewController(memo: memo)
        let secondaryNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        memoDetailViewController.listViewControllerDelegate = primaryViewController
        
        primaryViewController.showDetailViewController(secondaryNavigationController, sender: self)
    }
    
    func initiateSecondaryViewControllerIfNeeded(_ memo: MemoEntity) {
        guard let secondaryViewController = viewControllers.last,
              let navigationController = secondaryViewController as? UINavigationController,
              let topViewController = navigationController.topViewController,
              let memoDetailViewController = topViewController as? MemoDetailViewController else {
            return
        }
        
        guard memoDetailViewController.isCurrentEntity(memo) else {
            return
        }
        
        memoDetailViewController.updateStatusToWillDelete()
        
        let guideSecondaryViewController = MemoDetailViewController(isEditable: false)
        let secondaryNavigationController = UINavigationController(rootViewController: guideSecondaryViewController)
        
        primaryViewController.showDetailViewController(secondaryNavigationController, sender: self)
    }
}
