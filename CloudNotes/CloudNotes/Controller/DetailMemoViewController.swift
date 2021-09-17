//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/01.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    weak var delegate: DetailMemoDelegate?
    var index = IndexPath()
    
    var memo: Memo? {
        didSet {
            configureText()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addSubView()
        configureAutoLayout()
        configureNavigationItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var detailMemoTextView: UITextView = {
        let detailMemoTextView = UITextView()
        detailMemoTextView.font = UIFont.systemFont(ofSize: 20)
        detailMemoTextView.translatesAutoresizingMaskIntoConstraints = false
        return detailMemoTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureText()
        registerNotification()
    }
    
    private func moveToMasterViewInCompact() {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            if let masterViewNavigationController = self.navigationController?.parent as? UINavigationController {
                masterViewNavigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    private func configureText() {
        if memo == nil {
            detailMemoTextView.text = ""
        }
        memo.flatMap { detailMemoTextView.text = $0.title + "\n\n" + $0.body }
    }
    
    private func configureNavigationItem() {
        let moreFunctionButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                              style: .plain,
                                                              target: self,
                                                              action:  #selector(touchUpMoreFunctionButton))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(showSaveAlert))
        
        moreFunctionButton.isEnabled = false
        doneButton.isEnabled = false
        
        self.navigationItem.rightBarButtonItems = [moreFunctionButton, doneButton]
    }
    
    private func addSubView() {
        view.addSubview(detailMemoTextView)
    }
    
    private func configureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            detailMemoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailMemoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailMemoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailMemoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func ableUserInteraction() {
        detailMemoTextView.isUserInteractionEnabled = true
        if let items = self.navigationItem.rightBarButtonItems {
            for item in items {
                item.isEnabled = true
            }
        }
    }
    
    @objc func saveMemo() {
        let minumumLine = 3
        let title = detailMemoTextView.text.lines[0]
        var body = ""
        
        if minumumLine <= detailMemoTextView.text.lines.count {
            body = detailMemoTextView.text.lines[(minumumLine - 1)...].joined(separator: "\n")
        }
        
        let newMemo = Memo(title: title, body: body, date: Date().timeIntervalSince1970, identifier: memo?.identifier)
        memo = newMemo
        guard let savedMemo = memo else { return }
        delegate?.saveMemo(with: savedMemo, index: self.index)
    }
}

// MARK:- Button Action
extension DetailMemoViewController {
    
    @objc private func showDeleteAlert() {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil , preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { [self] (action) in
            delegate?.deleteMemo(index: self.index)
            moveToMasterViewInCompact()
            configureText()
            detailMemoTextView.isUserInteractionEnabled = false
            if let items = self.navigationItem.rightBarButtonItems {
                for item in items {
                    item.isEnabled = false
                }
            }
        }
        let close = UIAlertAction(title: "닫기", style: .destructive, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func showSaveAlert() {
        let alert = UIAlertController(title: "저장하시겠습니까?", message: nil , preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { [self] (action) in
            saveMemo()
            moveToMasterViewInCompact()
        }
        let close = UIAlertAction(title: "닫기", style: .destructive, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
    func shareMemo() {
        let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: [])
        present(activityViewController, animated: true)
    }
    
    @objc func touchUpMoreFunctionButton() {
        let actionSheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] (action) in
            showDeleteAlert()
        }
        let share = UIAlertAction(title: "Share", style: .default) { [self] (action) in
            shareMemo()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(delete)
        actionSheet.addAction(share)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK:- KeyBoard Action
extension DetailMemoViewController {
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        detailMemoTextView.contentInset = contentInset
        detailMemoTextView.scrollIndicatorInsets = contentInset
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShown(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        
        detailMemoTextView.contentInset = contentInset
        detailMemoTextView.scrollIndicatorInsets = contentInset
    }
}

extension String {
    var lines: [String] { return self.components(separatedBy: NSCharacterSet.newlines)}
}
