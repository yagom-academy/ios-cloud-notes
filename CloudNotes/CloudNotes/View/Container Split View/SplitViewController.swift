//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    private var primaryViewController: PrimaryViewController?
    private var secondaryViewController: SecondaryViewController?
        
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        
        primaryViewController = PrimaryViewController(rootDelegate: self)
        secondaryViewController = SecondaryViewController(rootDelegate: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
        
        self.delegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: - Managing Display
extension SplitViewController {
    func showSelectedDetail(by memo: MemoModel, at indexPath: IndexPath, showPage isShowing: Bool) {
        secondaryViewController?.updateDetailView(by: memo, at: indexPath)
        if isShowing { show(.secondary) }
    }
    
    func makeEmptyDetail() {
        secondaryViewController?.initDetailView()
        show(.primary)
    }
}

// MARK: - Managing Display from Primary Secondary
extension SplitViewController: SecondaryDetailViewDelegate {
    func reloadPrimaryTableView() {
        primaryViewController?.tableView.reloadData()
    }
}
