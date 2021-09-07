//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class SecondaryViewController: UIViewController {
    private var secondaryView: SecondaryView?
    private var tempMemo: Memo?
    private let twiceLineBreaks = "\n\n"
    
    init() {
        super.init(nibName: nil, bundle: nil)
        secondaryView = SecondaryView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    func updateDetailView(by memo: Memo?) {
        memo.flatMap { memo in
            let text = memo.title + twiceLineBreaks + memo.body
            self.secondaryView?.configure(by: text)
        }
    }
}
