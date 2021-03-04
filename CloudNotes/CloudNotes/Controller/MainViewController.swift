//
//  MainViewController.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/19.
//

import UIKit

final class MainViewController: UISplitViewController {
    
    let listViewController = ListViewController()
    let detailViewController = DetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainViewController()
    }
    
    private func setMainViewController() {
        self.delegate = self
        
        listViewController.listViewDelegate = self
        
        let listViewNavigationController = UINavigationController(rootViewController: listViewController)
        let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)

        self.viewControllers = [listViewNavigationController, detailViewNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}

extension MainViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension MainViewController: ListViewDelegate {
    func didTapListCell(memo: Memo?, selectedIndex: Int) {
        (self.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: false)
        
        let detailView = DetailViewController()
        detailView.detailViewDelegate = self
        detailView.view.backgroundColor = .white
        guard let memo = memo else { return }
        detailView.index = selectedIndex
        detailView.memoTextView.text = memo.title
        detailView.memoTextView.text += memo.contents ?? ""
        
        (self.viewControllers.last as? UINavigationController)?.pushViewController(detailView, animated: false)
    }
    
    func didTapAddButton() {
        (self.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: false)
        
        let addView = AddViewController()
        addView.addViewDelegate = self
        
        (self.viewControllers.last as? UINavigationController)?.pushViewController(addView, animated: false)
    }
}

extension MainViewController: AddViewDelegate {
    func didCreateMemo() {
        listViewController.tableView.reloadData()
    }
}

extension MainViewController: DetailViewDelegate {
    func didDeleteMemo() {
        listViewController.tableView.reloadData()
    }
}
