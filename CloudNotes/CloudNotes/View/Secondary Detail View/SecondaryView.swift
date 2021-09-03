//
//  SecondaryView.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/03.
//

import UIKit

class SecondaryView: UIView {
    
    let textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.backgroundColor = .red
        view.text = "alksmflkmfblsm;lbmk;erj"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension SecondaryView: UITextViewDelegate {
    
}

extension SecondaryView {
    
    func configure(by text: String?) {
        self.textView.text = text
    }
    
}
