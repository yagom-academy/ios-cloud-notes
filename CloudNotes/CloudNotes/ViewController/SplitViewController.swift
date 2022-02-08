//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/07.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navcontroller 구성
        let listViewController = ListViewController()
        let noteViewController = NoteViewController()

        let listNavController = UINavigationController(rootViewController: listViewController)
        let noteNavController = UINavigationController(rootViewController: noteViewController)
        
        viewControllers = [listNavController, noteNavController]
//        setViewController(listNavController, for: .primary)
//        setViewController(noteNavController, for: .secondary)
        
        // displaymode 적용
        preferredDisplayMode = .oneBesideSecondary
    }
}
