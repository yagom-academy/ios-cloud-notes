//
//  DetailMemoVC.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

class DetailMemoVC: UIViewController {
    static let identifier: String = "DetailMemoVC"
    var splitView: UISplitViewController?
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "title Text"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        return titleLabel
    }()
    
    var body: UILabel = {
        let body = UILabel()
        body.text = "body Text"
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = UIFont.systemFont(ofSize: 20)
        body.numberOfLines = 0
        
        return body
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraint()
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func configureDetail(data: Memo) {
        titleLabel.text = data.title
        body.text = data.body

    }
    
    func configureConstraint() {
        let margins = view.safeAreaLayoutGuide
        
        view.addSubview(titleLabel)
        view.addSubview(body)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: body.topAnchor, constant: -30),
            
            body.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            body.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
        ])
    }
    
    
}
