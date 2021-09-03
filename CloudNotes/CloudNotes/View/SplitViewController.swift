//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    
    var primaryViewController: PrimaryViewController?
    var secondaryViewController: SecondaryViewController?
    
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        primaryViewController = PrimaryViewController()
        secondaryViewController = SecondaryViewController()
        
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        primaryViewController?.delegate = self
        secondaryViewController?.delegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension SplitViewController: SelectedCellDelegate, ChangedMemoDelegate {
    func showSelectedDetail(memo: Memo, index: Int?) {
        secondaryViewController?.updateDetailView(by: memo, index: index)
        if index != nil {
            show(.secondary)
        }
    }
    
    func updateListItem(memo: Memo?, index: Int?) {
        print("변경 완료 \(memo), \(index)")
        // Primary로 전달
    }
}
