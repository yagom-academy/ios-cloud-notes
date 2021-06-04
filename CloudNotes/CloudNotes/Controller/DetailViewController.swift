//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class DetailViewController: UIViewController, SendDataDelegate {
    
    var memoDetailtextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.black
        view.text = "내용을 입력하세요"
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(editMemo))
        self.view.addSubview(memoDetailtextView)
        setTextViewConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundColor()
    }
    
    @objc func editMemo() {
    }
    
    func sendData(data: MemoData) {
        self.memoDetailtextView.text = "\(data.title)\n\n" + "\(data.body)"
    }
    
    func isRegularTextViewColor(regular: Bool) {
        if regular {
            self.memoDetailtextView.backgroundColor = UIColor.white
            self.view.backgroundColor = UIColor.white
        }
    }
    
    private func setBackgroundColor() {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            self.memoDetailtextView.backgroundColor = UIColor.lightGray
        }
        else {
            self.memoDetailtextView.backgroundColor = UIColor.white
        }
    }
    
    private func setTextViewConstraint() {
        self.memoDetailtextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.memoDetailtextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.memoDetailtextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.memoDetailtextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
}
