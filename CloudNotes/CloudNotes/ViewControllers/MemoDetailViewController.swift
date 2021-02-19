//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/18.
//

import UIKit

class MemoDetailViewController: UIViewController {
    // MARK: - UI property
    private lazy var memoDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    // MARK: - data property
    private var memo: MemoModel? {
        didSet {
            displayMemo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        setupUI()
        setupTextView()
        setupKeyboard()
        displayMemo()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if traitCollection.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
            navigationController?.navigationBar.isHidden = true
        } else {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    // MARK: - setup UI
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(memoDetailTextView)
        memoDetailTextView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        memoDetailTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        memoDetailTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        memoDetailTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupTextView() {
        memoDetailTextView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView(_:)))
        memoDetailTextView.addGestureRecognizer(tapGesture)
        memoDetailTextView.setTextViewAllDataDetectorTypes()
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        memoDetailTextView.isEditable = true
        memoDetailTextView.dataDetectorTypes = []
        memoDetailTextView.becomeFirstResponder()
    }
    
    private func setupKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil , action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(touchUpDoneButton(_:)))
        keyboardToolbar.items = [space, doneButton]
        
        memoDetailTextView.inputAccessoryView = keyboardToolbar
    }
    
    @objc func touchUpDoneButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func displayMemo() {
        guard let memo = memo else {
            return
        }
        self.navigationItem.title = memo.title
        memoDetailTextView.text = memo.body
        
    }
}

// MARK: - TextView Delegate
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.setTextViewAllDataDetectorTypes()
    }
}

extension MemoDetailViewController: MemoListSelectDelegate {
    func memoCellSelect(_ memo: MemoModel) {
        self.memo = memo
    }
}
