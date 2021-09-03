//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

protocol ChangedMemoDelegate: AnyObject {
    func updateListItem(memo: Memo?, index: Int?)
}

class SecondaryViewController: UIViewController {
    
    private var secondaryView: SecondaryView?
    
    weak var delegate: ChangedMemoDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        secondaryView = SecondaryView { temp, index in
            print("변경 완료 클로저")
            self.delegate?.updateListItem(memo: temp, index: index)
        }
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
        
        secondaryView?.textView.delegate = secondaryView
    }
}

extension SecondaryViewController {
    func updateDetailView(by memo: Memo?, index: Int?) {
        self.secondaryView?.configure(by: memo, index: index)
    }
}
