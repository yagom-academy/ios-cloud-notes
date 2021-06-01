//
//  NoteSplitViewController.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/01.
//

import UIKit

class NoteSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let first = ViewController1()
        let second = ViewController2()

        self.presentsWithGesture = false
        self.preferredSplitBehavior = .tile
        self.preferredDisplayMode = .oneBesideSecondary

        second.view.backgroundColor = .purple
        first.view.backgroundColor = .green
        viewControllers = [first, second]
    }

}

class ViewController1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        self.view.addSubview(label)
        self.navigationItem.title = "메모"
        label.text = "first"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

class ViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        view.addSubview(label)
        label.text = "second"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


