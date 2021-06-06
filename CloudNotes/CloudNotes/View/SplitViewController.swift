//
//  SplitVC.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSplitViewController()
    }
    
    private func configureSplitViewController() {
        let memoListViewController = UINavigationController(rootViewController: MemoListViewController(splitViewDelegate: self))
        let detailMemoViewController = UINavigationController(rootViewController: DetailMemoViewController())
        
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        self.viewControllers = [memoListViewController, detailMemoViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}

protocol SplitViewDelegate {
    func didSelectRowAt(data: Memo)
}

extension SplitViewController: SplitViewDelegate {
    func didSelectRowAt(data: Memo) {
        let detailMemoViewController = DetailMemoViewController()
        
        detailMemoViewController.configureDetailText(data: data)
        showDetailViewController(UINavigationController(rootViewController: detailMemoViewController), sender: nil)
    }
}
