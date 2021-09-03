//
//  DetailTextViewController.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import UIKit

class DetailTextViewController: UIViewController {
    
    static var identifier = "DetailTextViewController"
    var memoData: Memo? {
        didSet {
            detailTextView.text = memoData?.description
        }
    }
    
    let detailTextView: UITextView = {
        let detailTextView = UITextView()
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        
        return detailTextView
    }()
    
    func addView() {
        view.addSubview(detailTextView)
    }
    
    override func viewDidLoad() {
        addView()
        textViewLayout()
    }
    
    private func textViewLayout() {
        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: view.topAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
