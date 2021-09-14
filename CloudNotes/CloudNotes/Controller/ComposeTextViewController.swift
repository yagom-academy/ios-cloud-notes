//
//  ComposeTextViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit

final class ComposeTextViewController: UIViewController, TextViewContraintable {
    // MARK: Property
    weak var delegate: ComposeTextViewControllerDelegate?
    private var composeTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.scrollsToTop = true
        textView.autocorrectionType = .no
        
        return textView
    }()
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTextViewFullScreen(composeTextView, superView: view)
    }
}

extension ComposeTextViewController {
    
    func setupNavigationItems() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                 target: self,
                                                 action: #selector(didTapButton))
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                target: self,
                                                action: #selector(didTapButton))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        if sender == navigationItem.rightBarButtonItem {
            delegate?.didTapSaveButton(composeTextView.text)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ComposeTextViewController {
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(composeTextView)
    }
}
