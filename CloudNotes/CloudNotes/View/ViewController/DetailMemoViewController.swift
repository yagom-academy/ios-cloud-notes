//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/01.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var memoTitle = UILabel()
    var memoMain = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        addSubviewInView()
        setUpScrollView()
        setUpContentView()
        setUpMemoTitleLabel()
        setUpMemoMainLabel()
    }
    
    private func addSubviewInView() {
        self.view.addSubview(scrollView)
        addSubviewInScrollView()
    }
    
    private func addSubviewInScrollView() {
        self.scrollView.addSubview(contentView)
        addSubviewInContentView()
    }
    
    private func addSubviewInContentView() {
        self.scrollView.addSubview(memoTitle)
        self.scrollView.addSubview(memoMain)
    }
    
    private func setUpScrollView() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            self.scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            self.scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
        ])
    }
    
    private func setUpContentView() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            self.contentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            self.contentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
        ])
    }
    
    
    private func setUpMemoTitleLabel() {
        self.memoTitle.numberOfLines = 0
        self.memoTitle.translatesAutoresizingMaskIntoConstraints = false
        memoTitle.font = memoTitle.font.withSize(25)
        memoTitle.textColor = .black
        NSLayoutConstraint.activate([
            self.memoTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            self.memoTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.memoTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            self.memoTitle.bottomAnchor.constraint(equalTo: memoMain.topAnchor, constant: -10),
        ])
    }
    
    private func setUpMemoMainLabel() {
        self.memoMain.numberOfLines = 0
        self.memoMain.translatesAutoresizingMaskIntoConstraints = false
        memoMain.textColor = .black
        NSLayoutConstraint.activate([
            self.memoMain.topAnchor.constraint(equalTo: memoTitle.bottomAnchor, constant: 10),
            self.memoMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.memoMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            self.memoMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(with memo: Memo) {
        memoTitle.text = memo.title
        memoMain.text = memo.main
    }
}
