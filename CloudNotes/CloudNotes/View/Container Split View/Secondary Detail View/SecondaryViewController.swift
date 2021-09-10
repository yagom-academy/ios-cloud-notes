//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class SecondaryViewController: UIViewController {
    private var secondaryView: SecondaryView?
    private let twiceLineBreaks = "\n\n"
    private let hidableDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(resignFromTextView))
    private let seeMoreStaticButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        secondaryView = SecondaryView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SecondaryViewController - viewWillAppear")
        setBarButtons(isHide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SecondaryViewController - viewWillDisappear")
        resignFromTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryView.flatMap(self.view.addSubview(_:))
        secondaryView.flatMap({ secondary in
            NSLayoutConstraint.activate([
                secondary.topAnchor.constraint(equalTo: self.view.topAnchor),
                secondary.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                secondary.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                secondary.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Keyboard Notification
extension SecondaryViewController {
    @objc func keyboardWasShown(_ notification: Notification) {
        setBarButtons(isHide: false)
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        setBarButtons(isHide: true)
    }
    
    func setBarButtons(isHide: Bool) {
        self.navigationItem.rightBarButtonItems = isHide ? [seeMoreStaticButton] : [hidableDoneButton, seeMoreStaticButton]
    }
}

extension SecondaryViewController {
//    func updateMemo(by editedText: String) {
//        var split = editedText.split(whereSeparator: \.isNewline)
//        let title = String(split.removeFirst())
//        let body = split.joined(separator: twiceLineBreaks)
//        let nowDate = Date().timeIntervalSince1970
//
//        let updatedMemo = Memo(title: title, body: body, lastModified: nowDate)
//    }
    
    func updateDetailView(by memo: MemoModel) {
        let text = memo.title + twiceLineBreaks + memo.body
        self.secondaryView?.configure(by: text)
    }
}

// MARK: - Keyboard Notification
extension SecondaryViewController {
    @objc func resignFromTextView() {
        secondaryView?.textView.resignFirstResponder()
    }
}
