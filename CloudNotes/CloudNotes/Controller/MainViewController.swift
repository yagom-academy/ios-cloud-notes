//
//  MainViewController.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import UIKit

class MainViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        configure()
    }
    
    private func configure() {
        let secondVC = DetailTextViewController()
        let menuVC = MenuTableViewController(style: .plain, buttonDelegate: secondVC)
        delegate = self
        secondVC.detailTextViewControllerDelegate = self
        menuVC.makeTest()
        setViewController(menuVC, for: .primary)
        setViewController(secondVC, for: .secondary)
    }
}

extension MainViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension MainViewController: DetailTextViewControllerDelegate {
    func showDetailTextView() {
        show(.secondary)
    }
}
