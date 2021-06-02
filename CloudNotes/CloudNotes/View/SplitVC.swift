//
//  SplitVC.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

class SplitVC: UISplitViewController, UISplitViewControllerDelegate {
    var root: UIViewController?
    var detail: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        return true
    }

    
}
