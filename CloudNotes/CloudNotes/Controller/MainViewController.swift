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
        let menuVC = MenuTableViewController(style: .plain)
        menuVC.delegate = self
        menuVC.makeTest()
        let secondVC = DetailTextViewController()
        
        setViewController(menuVC, for: .primary)
        setViewController(secondVC, for: .secondary)
    }
    
}

extension MainViewController: MenuTableViewControllerDelegate {
    func didTapTableItem(data: String) {
        let detailVC = viewController(for: .secondary) as? DetailTextViewController
        detailVC?.detailTextView.text = data
        show(.secondary)
    }
}
