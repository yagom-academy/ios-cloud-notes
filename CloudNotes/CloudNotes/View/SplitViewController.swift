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
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        
        self.delegate = self
        primaryViewController?.rootViewDelegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension SplitViewController: PrimaryListDelegate {
    func showSelectedDetail(by memo: Memo) {
        secondaryViewController?.updateDetailView(by: memo)
        show(.secondary)
    }
}

extension NSObject {
    public class var className: String {
        return String(describing: self)
    }
}
