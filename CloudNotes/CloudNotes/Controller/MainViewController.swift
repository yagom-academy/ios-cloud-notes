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
        menuVC.makeTest()
        let secondVC = DetailTextViewController()
        secondVC.title = "Home"
        splitVC.viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: secondVC)
        ]
        present(splitVC, animated: false)
    }
    
}
