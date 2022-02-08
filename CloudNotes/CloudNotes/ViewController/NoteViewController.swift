//
//  NoteViewController.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/07.
//

import UIKit

class NoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test = UILabel()
        view.backgroundColor = .white
        view.addSubview(test)
        test.text = "test" // test를 위해서 출력할 라벨
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 오른쪽 메모 추가 버튼을 위한 임시 코드
        if let splitViewController = self.splitViewController {
            let navigationItem = self.navigationItem
            navigationItem.setLeftBarButton(splitViewController.displayModeButtonItem, animated: false)
            navigationItem.leftItemsSupplementBackButton = true
            print(splitViewController.isCollapsed)
        }
        super.viewWillAppear(animated)
    }
}
