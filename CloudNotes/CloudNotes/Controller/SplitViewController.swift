//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    // MARK: Popover Properties
    var activityViewPopover: UIPopoverPresentationController?
    var actionSheetPopover: UIPopoverPresentationController?
    
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
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        configurePadSetting(for: actionSheetPopover, status: .transition)
        configurePadSetting(for: activityViewPopover, status: .transition)
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

// MARK: Alertable
extension SplitViewController: Alertable {
    func showActionSheet(of indexPath: IndexPath, noteTitle: String, deleteHandler: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: ActionSheet.title,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: ActionSheet.shareAction, style: .default) { _ in
            self.showActivityView(of: indexPath, noteTitle: noteTitle)
        }
        
        let deleteAction = UIAlertAction(title: ActionSheet.deleteAction, style: .destructive) { _ in
            self.showDeleteAlert(of: indexPath, deleteHandler: deleteHandler)
        }
        
        let cancelAction = UIAlertAction(title: ActionSheet.cancelAction, style: .cancel)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        configurePadSetting(for: actionSheet.popoverPresentationController, status: .load)
        actionSheetPopover = actionSheet.popoverPresentationController

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showActivityView(of indexPath: IndexPath, noteTitle: String) {
        let shareText: String = noteTitle
        let activityView = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        configurePadSetting(for: activityView.popoverPresentationController, status: .load)
        activityViewPopover = activityView.popoverPresentationController
        
        self.present(activityView, animated: true, completion: nil)
    }
    
    func showDeleteAlert(of indexPath: IndexPath, deleteHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: Alert.title,
                                      message: Alert.message,
                                      preferredStyle: .alert)
  
        let cancelAction = UIAlertAction(title: Alert.cancelAction, style: .cancel)
        
        let deleteAction = UIAlertAction(title: Alert.deleteAction, style: .destructive) { _ in
            deleteHandler()
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
