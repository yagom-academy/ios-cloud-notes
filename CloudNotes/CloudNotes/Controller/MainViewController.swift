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
        viewControllers = [menuVC, secondVC]
    }
    
}

extension MainViewController: didTapButtonDelegate {
    func didTapTableItem(data: String) {
        (viewControllers.last as? UINavigationController)?.popViewController(animated: true)
        let detailVC = DetailTextViewController()
        detailVC.detailTextView.text = data
        (viewControllers.last as? UINavigationController)?.pushViewController(detailVC, animated: true)
    }
    
    
}
