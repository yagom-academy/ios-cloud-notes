//
//  SecondaryView.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/03.
//

import UIKit

class SecondaryView: UIView {
    
    typealias DidChangedMemoAction = (Memo?, Int?) -> Void
    
    private var tempMemo: Memo?
    private var tempIndex: Int?
    private var didEndEditingMemoAction: DidChangedMemoAction?
    
    let textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(didChangingMemoAction: @escaping DidChangedMemoAction) {
        super.init(frame: .zero)
        self.didEndEditingMemoAction = didChangingMemoAction
        addSubview(textView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension SecondaryView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        print("변경 완료 didEnd")
        tempMemo?.body = textView.text
        tempMemo?.lastModified = Date().timeIntervalSince1970
        didEndEditingMemoAction?(tempMemo, tempIndex)
    }
}

extension SecondaryView {
    func configure(by memo: Memo?, index: Int?) {
        self.tempMemo = memo
        self.tempIndex = index
        self.textView.text = memo?.body
    }
}
