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
        
        primaryViewController = PrimaryViewController()
        secondaryViewController = SecondaryViewController()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
        
        self.delegate = self
        primaryViewController?.rootViewDelegate = self
        secondaryViewController?.rootViewDelegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: - Communication from Primary View
extension SplitViewController: PrimaryListDelegate {
    func showSelectedDetail(by memo: MemoModel, at indexPath: IndexPath, showPage isShowing: Bool) {
        secondaryViewController?.updateDetailView(by: memo, at: indexPath)
        if isShowing { show(.secondary) }
    }
    
    func dismissDetail() {
        secondaryViewController?.initDetailView()
        show(.primary)
    }
}

// MARK: - Communication from Secondary View
extension SplitViewController: SecondaryDetailDelegate {
    func detailDeleted(at indexPath: IndexPath) {
        primaryViewController?.deleteMemo(at: indexPath)
    }
    
    func detailEdited(at indexPath: IndexPath) {
    
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    var className: String {
        return type(of: self).className
    }
}
