//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/05.
//

import UIKit

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigationBar()
    }

    func configureView() {
        view.backgroundColor = .systemGray4
    }

    func configureNavigationBar() {
        let itemImage = UIImage(systemName: "ellipsis.circle")
        let rightBarButtonItem = UIBarButtonItem(image: itemImage, style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }

}
