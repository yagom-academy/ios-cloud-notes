//
//  MainSplitViewController.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

final class SplitViewController: UISplitViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    setPreferredStyle()
  }
  
  private func setPreferredStyle() {
    self.preferredSplitBehavior = .tile
    self.preferredDisplayMode = .oneBesideSecondary
  }
}

extension SplitViewController: UISplitViewControllerDelegate {
  func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
    return .primary
  }
}
