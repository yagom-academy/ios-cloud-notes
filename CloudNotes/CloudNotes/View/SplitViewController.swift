//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/01.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let master = UINavigationController()
        let detail = UINavigationController()
        master.viewControllers = [MemoListViewController()]
        detail.viewControllers = [MemoDetailViewController()]
        self.viewControllers = [master, detail]
        preferredDisplayMode = .oneBesideSecondary
        self.view.backgroundColor = .white
    }
}
