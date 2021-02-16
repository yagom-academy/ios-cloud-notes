//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

protocol MemoViewControllerDelegate {
    func setMemo(_ memo: String)
    func getMemoViewController() -> MemoViewController
}

class MemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
