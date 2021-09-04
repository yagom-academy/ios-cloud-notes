//
//  MainViewController.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import UIKit

class MainViewController: UIViewController {
    
    let splitVC = UISplitViewController(style: .doubleColumn)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitVC.modalPresentationStyle = .fullScreen
        splitVC.preferredSplitBehavior = .displace
        splitVC.preferredDisplayMode = .oneBesideSecondary
        configure()
    }
    
    private func configure() {
        let menuVC = MenuTableViewController(style: .plain)
        menuVC.delegate = self
        menuVC.makeTest()
        let secondVC = DetailTextViewController()
        splitVC.viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: secondVC)
        ]
        present(splitVC, animated: false)
    }
    
}

extension MainViewController: didTapButtonDelegate {
    func didTapTableItem(data: String) {
        (splitVC.viewControllers.last as? UINavigationController)?.popViewController(animated: true)
        let detailVC = DetailTextViewController()
        detailVC.detailTextView.text = data
        (splitVC.viewControllers.last as? UINavigationController)?.pushViewController(detailVC, animated: true)
    }
    
    
}
