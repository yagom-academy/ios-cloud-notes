//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, SendDataDelegate {
    
    var textView: UITextView = {
        let view = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.black
        view.text = "내용을 입력하세요"
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(editMemo))
        self.view.addSubview(textView)
        setTextViewConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundColor()
    }
    
    @objc func editMemo() {
    }
    
    func sendData(data: MemoData) {
        self.textView.text = "\(data.title)\n" + "\(data.body)"
    }
    
    private func setBackgroundColor() {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            self.textView.backgroundColor = UIColor.lightGray
        }
        else {
            self.textView.backgroundColor = UIColor.white
        }
    }
    
    private func setTextViewConstraint() {
        self.textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
}
