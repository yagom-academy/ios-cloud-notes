//
//  AlertManager.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/16.
//

import UIKit

// MARK: Pad Setting
class AlertManager {
    weak var splitViewController: UISplitViewController?
    
    // MARK: Alertable Properties
    var activityViewPopover: UIPopoverPresentationController?
    var actionSheetPopover: UIPopoverPresentationController?
    var currentActivityViewSender: ActivityViewSender = .button
    
    init(view: UISplitViewController) {
        splitViewController = view
    }
    
    enum ViewStatus {
        case load
        case transition
    }
    
    private func configurePadSetting(for popover: UIPopoverPresentationController?,
                                     status: ViewStatus,
                                     sender: ActivityViewSender)
    {
        if UIDevice.current.userInterfaceIdiom == .pad {
            switch sender {
            case .cellSwipe:
                showPopoverFromCell(popover: popover, status: status)
            case .button:
                showPopoverFromButton(popover: popover, status: status)
            }
        }
    }
    
    private func showPopoverFromCell(popover: UIPopoverPresentationController?, status: ViewStatus) {
        guard let splitView = splitViewController?.view else { return }
        
        let rectX = status == .load ? splitView.bounds.midX : splitView.bounds.midY
        let rectY = status == .load ? splitView.bounds.midY : splitView.bounds.midX
        
        let newRect = CGRect(x: rectX, y: rectY, width: .zero, height: .zero)
        popover?.sourceView = splitView
        popover?.sourceRect = newRect
        popover?.permittedArrowDirections = []
    }
    
    private func showPopoverFromButton(popover: UIPopoverPresentationController?, status: ViewStatus) {
        guard let splitView = splitViewController?.view,
              let detailNavigationController = splitViewController?.viewControllers.last
                                                                    as? UINavigationController,
              let detailViewController = detailNavigationController.topViewController
                                                                    as? NoteDetailViewController,
              let buttonWidth = detailViewController.navigationItem.rightBarButtonItem?.image?.size.width
        else {
            return
        }

        let sourceViewX = status == .load ? splitView.bounds.maxX : splitView.bounds.maxY
        let sourceViewY = status == .load ? splitView.bounds.minY : splitView.bounds.minX
        
        let rectX = sourceViewX - buttonWidth
        let rectY = sourceViewY + detailNavigationController.navigationBar.frame.height + buttonWidth / 2
        let newRect = CGRect(x: rectX, y: rectY, width: .zero, height: .zero)
        
        popover?.sourceView = splitView
        popover?.sourceRect = newRect
        popover?.permittedArrowDirections = .up
    }
}
extension AlertManager: Alertable {
    func configurePadTransition() {
        configurePadSetting(for: actionSheetPopover, status: .transition, sender: currentActivityViewSender)
        configurePadSetting(for: activityViewPopover, status: .transition, sender: currentActivityViewSender)
    }

    func showActionSheet(of indexPath: IndexPath, noteTitle: String, deleteHandler: @escaping () -> Void)
    {
        let actionSheet = UIAlertController(title: ActionSheet.title,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: ActionSheet.shareAction, style: .default) { _ in
            self.showActivityView(of: indexPath, noteTitle: noteTitle, sender: .button)
        }
        
        let deleteAction = UIAlertAction(title: ActionSheet.deleteAction, style: .destructive) { _ in
            self.showDeleteAlert(of: indexPath, deleteHandler: deleteHandler)
        }
        
        let cancelAction = UIAlertAction(title: ActionSheet.cancelAction, style: .cancel)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        configurePadSetting(for: actionSheet.popoverPresentationController, status: .load, sender: .button)
        actionSheetPopover = actionSheet.popoverPresentationController

        splitViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func showActivityView(of indexPath: IndexPath, noteTitle: String, sender: ActivityViewSender) {
        let shareText: String = noteTitle
        let activityView = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        configurePadSetting(for: activityView.popoverPresentationController, status: .load, sender: sender)
        activityViewPopover = activityView.popoverPresentationController
        currentActivityViewSender = sender
        
        splitViewController?.present(activityView, animated: true, completion: nil)
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
        
        splitViewController?.present(alert, animated: true, completion: nil)
    }
}
