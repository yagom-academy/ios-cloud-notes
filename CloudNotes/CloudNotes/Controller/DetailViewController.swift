//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - Properties
    var splitView: SplitViewController?
    var indexPath: IndexPath?
    let textView = UITextView()

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        addViews()
        configureTextViewLayout()
    }
    
    // MARK: - Methods
    func update(data: [CloudNoteItem]?, indexPath: IndexPath) {
        self.textView.text = data?[indexPath.row].body
        self.indexPath = indexPath
    }
    
    private func addViews() {
        view.addSubview(textView)
    }
    
    private func configureTextViewLayout() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
                                        textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
                                        textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
                                        textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
                                        textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)])
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        splitView?.menu?.update(indexPath: indexPath ?? IndexPath())
        splitView?.menu?.tableView.reloadData()
    }
}
