//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class SecondaryViewController: UIViewController {
    
    let secondaryView = SecondaryView()
    var memo: Memo?
    
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
        
        secondaryView.textView.delegate = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SecondaryViewController: UITextViewDelegate {
    
}
