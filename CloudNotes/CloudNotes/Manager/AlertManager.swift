//
//  AlertManager.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/16.
//

import UIKit

// MARK: Pad Setting
class AlertManager {
    weak var splitView: UISplitViewController?
    
    // MARK: Alertable Properties
    var activityViewPopover: UIPopoverPresentationController?
    var actionSheetPopover: UIPopoverPresentationController?
    
    init(view: UISplitViewController) {
        splitView = view
    }
    
    enum ViewStatus {
        case load
        case transition
    }
    
    private func configurePadSetting(for popover: UIPopoverPresentationController?, status: ViewStatus) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            guard let view = splitView?.view else { return }
            let rectX = status == .load ? view.bounds.midX : view.bounds.midY
            let rectY = status == .load ? view.bounds.midY : view.bounds.midX
            let newRect = CGRect(x: rectX, y: rectY, width: .zero, height: .zero)
            popover?.sourceView = view
            popover?.sourceRect = newRect
            popover?.permittedArrowDirections = []
        }
    }
}
extension AlertManager: Alertable {
    func configurePadTransition() {
        configurePadSetting(for: actionSheetPopover, status: .transition)
        configurePadSetting(for: activityViewPopover, status: .transition)
    }

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

        splitView?.present(actionSheet, animated: true, completion: nil)
    }
    
    func showActivityView(of indexPath: IndexPath, noteTitle: String) {
        let shareText: String = noteTitle
        let activityView = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        configurePadSetting(for: activityView.popoverPresentationController, status: .load)
        activityViewPopover = activityView.popoverPresentationController
        
        splitView?.present(activityView, animated: true, completion: nil)
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
        
        splitView?.present(alert, animated: true, completion: nil)
    }
}
