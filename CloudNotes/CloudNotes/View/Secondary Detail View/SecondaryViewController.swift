//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

protocol ChangedMemoDelegate: AnyObject {
    func updateListItem(_ memo: Memo)
}

class SecondaryViewController: UIViewController {
    private var secondaryView: SecondaryView?
    private var tempMemo: Memo?
    private let twiceLineBreaks = "\n\n"
    weak var delegate: ChangedMemoDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        secondaryView = SecondaryView(
            endEditingAction: { editedData in
                self.updateMemo(by: editedData)
            }
        )
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
//        self.view = secondary
        self.view.addSubview(secondary)
        NSLayoutConstraint.activate([
            secondary.topAnchor.constraint(equalTo: self.view.topAnchor),
            secondary.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            secondary.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            secondary.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension SecondaryViewController {
    func updateMemo(by editedText: String) {
        guard var temp = tempMemo else { return }
        var split = editedText.split(whereSeparator: \.isNewline)
        let title = String(split.removeFirst())
        let body = split.joined(separator: twiceLineBreaks)
        let nowDate = Date().timeIntervalSince1970
        
        temp.updateMemo(title, body, nowDate)
        
        delegate?.updateListItem(temp)
    }
    
    func updateDetailView(by memo: Memo?) {
        if let temp = tempMemo {
            delegate?.updateListItem(temp)
        }
        self.tempMemo = memo
        memo.flatMap { memo in
            let text = memo.title + twiceLineBreaks + memo.body
            self.secondaryView?.configure(by: text)
        }
    }
}
