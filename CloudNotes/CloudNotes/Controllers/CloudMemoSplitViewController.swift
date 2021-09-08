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
        let secondaryViewController = MemoDetailViewController(memo: getFirstMemo())
        
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
    }
    
    private func generateNewMemo() -> Memo {
        let currentTime = Date().timeIntervalSince1970
        return Memo(title: "새로운 메모", body: "추가 텍스트 없음", lastModified: currentTime)
    }
    
    private func getFirstMemo() -> Memo {
        guard let memo = Memo.generateMemoList().first else {
            return generateNewMemo()
        }
        
        return memo
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
        guard let primaryNavigationController = viewControllers.first else {
            return
        }
        
        let memoDetailViewController = MemoDetailViewController(memo: generateNewMemo())
        let secondaryNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        primaryNavigationController.showDetailViewController(secondaryNavigationController, sender: self)
    }
}
