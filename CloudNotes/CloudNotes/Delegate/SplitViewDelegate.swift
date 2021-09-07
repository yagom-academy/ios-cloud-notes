//
//  SplitViewDelegate.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/06.
//

import UIKit

class SplitViewDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
            return .primary
        }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        svc.presentsWithGesture = false
    }
}
