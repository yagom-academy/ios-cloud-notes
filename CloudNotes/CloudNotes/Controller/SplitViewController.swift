//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    var activityViewPopover: UIPopoverPresentationController?
    var actionSheetPopover: UIPopoverPresentationController?
    lazy var alertManager = AlertManager(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setUpSplitView()
        initChildViewControllers()
        NotificationCenter.default
            .addObserver(self, selector: #selector(deleteSecondary), name: .deleteNotification, object: nil)
    }
    
    private func initChildViewControllers() {
        let primaryViewController = NoteListViewController()
        let secondaryViewController = NoteDetailViewController()
        let primaryChild = UINavigationController(rootViewController: primaryViewController)
        let secondaryChild = UINavigationController(rootViewController: secondaryViewController)
        
        setViewController(primaryChild, for: .primary)
        setViewController(secondaryChild, for: .secondary)
        
        primaryViewController.alertDelegate = alertManager
    }
    
    private func setUpSplitView() {
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        presentsWithGesture = false
    }
    
    @objc func deleteSecondary() {
        setViewController(nil, for: .secondary)
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: Pad Setting
extension SplitViewController {
    enum ViewStatus {
        case load
        case transition
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        alertManager.configurePadTransition()
    }
    
    private func configurePadSetting(for popover: UIPopoverPresentationController?, status: ViewStatus) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let rectX = status == .load ? view.bounds.midX : view.bounds.midY
            let rectY = status == .load ? view.bounds.midY : view.bounds.midX
            let newRect = CGRect(x: rectX, y: rectY, width: .zero, height: .zero)
            popover?.sourceView = view
            popover?.sourceRect = newRect
            popover?.permittedArrowDirections = []
        }
    }
}
