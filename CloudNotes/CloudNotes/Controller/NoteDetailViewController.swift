//
//  SecondaryChildViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit

class NoteDetailViewController: UIViewController {
    weak var delegate: NoteUpdater?
    private var bodyTextView = UITextView()
    private var indexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        bodyTextView.delegate = self
    }
    
    func initContent(of note: Note, at indexPath: IndexPath) {
        setUpDetailView(indexPath: indexPath)
        showContent(of: note)
        styleContent()
        layoutContent()
        bodyTextView.layoutIfNeeded()
    }
    
    private func setUpDetailView(indexPath: IndexPath) {
        self.indexPath = indexPath
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(showActionSheet)
        )
    }

    private func showContent(of note: Note) {
        bodyTextView.text = note.title + String.doubleLineBreaks + note.body
    }
    
    private func styleContent() {
        bodyTextView.font = UIFont.preferredFont(forTextStyle: .body)
        view.backgroundColor = .white
    }
    
    private func layoutContent() {
        view.addSubview(bodyTextView)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: ActionSheet.title,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: ActionSheet.shareAction, style: .default) { _ in
            self.showActivityView()
        }
        
        let deleteAction = UIAlertAction(title: ActionSheet.deleteAction, style: .destructive) { _ in
            self.showDeleteAlert()
        }
        
        let cancelAction = UIAlertAction(title: ActionSheet.cancelAction, style: .cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showActivityView() {
        
    }
    
    private func showDeleteAlert() {
        
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let indexPath = indexPath else { return }

        let updatedData = (title: textView.title ?? String.empty,
                           body: textView.body ?? String.empty,
                           lastModified: Date().timeIntervalSince1970)
        
        delegate?.updateNote(at: indexPath, with: updatedData)
    }
}
