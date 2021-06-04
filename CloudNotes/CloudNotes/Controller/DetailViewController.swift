//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, SendDataDelegate, UITextViewDelegate {
    
    let textView = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(displayInfomation))
        textView.textColor = UIColor.black

        textView.text = "테스트"
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            textView.backgroundColor = UIColor.lightGray
        } else {
            textView.backgroundColor = UIColor.white
        }
    }
    
    @objc func displayInfomation() {
    }
    
    func sendData(data: MemoData) {
        self.textView.text = "\(data.title)\n" + "\(data.body)"
    }
    
}
