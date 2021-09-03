//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignColumnsToChildVC(primary: MemoListViewController(), secondary: MemoDetailViewController(), supplementary: nil)
    }
    
    private func assignColumnsToChildVC(primary: UIViewController, secondary: UIViewController, supplementary: UINavigationController?) {
        setViewController(primary, for: .primary)
        setViewController(secondary, for: .secondary)
        setViewController(supplementary, for: .supplementary)
    }
}
