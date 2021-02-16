//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setNavigation() {
        self.title = "메모"
        self.view.backgroundColor = .gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goToAddMemoVeiwController))
    }
    
    @objc private func goToAddMemoVeiwController() {
       
    }
}

