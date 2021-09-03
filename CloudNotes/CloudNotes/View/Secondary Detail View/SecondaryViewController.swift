//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class SecondaryViewController: UIViewController {
    
    private let secondaryView = SecondaryView()
    private var memo: Memo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view = secondaryView
        self.view.addSubview(secondaryView)
        NSLayoutConstraint.activate([
            secondaryView.topAnchor.constraint(equalTo: self.view.topAnchor),
            secondaryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            secondaryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            secondaryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        secondaryView.textView.delegate = secondaryView
    }
}

extension SecondaryViewController {
    func updateDetailView(by text: String?) {
        self.secondaryView.configure(by: text)
    }
}
