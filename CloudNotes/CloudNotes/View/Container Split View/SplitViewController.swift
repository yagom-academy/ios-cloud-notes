//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    private var primaryViewController: PrimaryViewController?
    private var secondaryViewController: SecondaryViewController?
    private let coreManager: MemoCoreDataManager = MemoCoreDataManager()
        
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        
        primaryViewController = PrimaryViewController(coreManager: coreManager)
        secondaryViewController = SecondaryViewController(coreManager: coreManager)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
        
        self.delegate = self
        primaryViewController?.rootDelegate = self
        secondaryViewController?.rootDelegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: - Managing Display from Primary
extension SplitViewController: PrimaryTableViewDelegate {
    func showSelectedDetail(at indexPath: IndexPath?, isShow: Bool) {
        secondaryViewController?.drawDetailView(at: indexPath)
        if isShow { show(.secondary) }
    }
}

// MARK: - Managing Display from Primary Secondary
extension SplitViewController: SecondaryDetailViewDelegate {
    func reloadPrimaryTableView() {
        primaryViewController?.tableView.reloadData()
    }
    
    func showPrimaryTableView() {
        show(.primary)
    }
}
