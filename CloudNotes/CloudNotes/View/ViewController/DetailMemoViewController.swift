//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/01.
//

import UIKit

class DetailMemoViewController: UIViewController, UITextViewDelegate {
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var memoTextView = UITextView()
    var memoMain = UITextView()
    
    lazy var rightNvigationItem: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        memoTextView.delegate = self
        memoTextView.contentInsetAdjustmentBehavior = .automatic
        memoTextView.textAlignment = NSTextAlignment.justified
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNvigationItem)
        self.view.addSubview(memoTextView)
        setUpMemoTextView()
    }
        
    private func setUpMemoTextView() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.memoTextView.translatesAutoresizingMaskIntoConstraints = false
        self.memoTextView.font = self.memoTextView.font?.withSize(20)
        NSLayoutConstraint.activate([
            self.memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            self.memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
        ])
    }

    
    func configure(with memo: Memo) {
        memoTextView.text = "\n\n" + memo.title + "\n\n" + memo.body
    }
}
