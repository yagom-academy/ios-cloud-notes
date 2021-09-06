//
//  DetailTextViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/03.
//

import UIKit

class DetailTextViewController: UIViewController {
    
    // MARK: - Properties
    private var memo: Savable?
    
    private let scrollView = UIScrollView()
    
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = memo?.title
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = memo?.body
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        changeBackgroundColor(of: scrollView, by: .white)
        configureScrollViewAnchor()
        
        
        scrollView.addSubview(titleTextView)
        configureTitleViewAnchor()
        

        scrollView.addSubview(bodyTextView)
        configureBodyViewAnchor()
    }
    
    // MARK: - Methods
    func configure(with memo: Savable) {
        self.memo = memo
    }
    
    private func changeBackgroundColor(of view: UIView, by color: UIColor) {
        view.backgroundColor = color
    }
    
    // MARK: - Auto Layout
    private func configureScrollViewAnchor() {
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func configureTitleViewAnchor() {
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        titleTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        titleTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
    }
    
    private func configureBodyViewAnchor() {
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        
        bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        bodyTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        bodyTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        bodyTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
    }
}
