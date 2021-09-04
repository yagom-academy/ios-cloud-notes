//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

protocol ChangedMemoDelegate: AnyObject {
    func updateListItem(memo: Memo?)
}

class SecondaryViewController: UIViewController {
    private var secondaryView: SecondaryView?
    private var tempMemo: Memo?
    let doubleNewLine = "\n\n"
    weak var delegate: ChangedMemoDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        secondaryView = SecondaryView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let secondary = secondaryView else {
            print("에러처리 필요 - SecondaryView 초기화 실패")
            return
        }
//        self.view = secondaryView
        self.view.addSubview(secondary)
        NSLayoutConstraint.activate([
            secondary.topAnchor.constraint(equalTo: self.view.topAnchor),
            secondary.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            secondary.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            secondary.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        secondaryView?.textView.delegate = self
    }
}

extension SecondaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        var split = textView.text.split(whereSeparator: \.isNewline)
        let title = String(split.removeFirst())
        let body = split.joined(separator: doubleNewLine)
        
        tempMemo?.title = title
        tempMemo?.body = body
        tempMemo?.lastModified = Date().timeIntervalSince1970
        
        delegate?.updateListItem(memo: tempMemo)
    }
}

extension SecondaryViewController {
    func updateDetailView(by memo: Memo?) {
        if tempMemo != nil {
            delegate?.updateListItem(memo: tempMemo)
        }
        self.tempMemo = memo
        memo.flatMap { memo in
            let text = memo.title + doubleNewLine + (memo.body ?? "")
            self.secondaryView?.configure(by: text)
        }
    }
}
