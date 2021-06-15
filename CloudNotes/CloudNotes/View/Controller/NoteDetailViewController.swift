//
//  NoteDetail.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit
import CoreData

final class NoteDetailViewController: UIViewController {
    private lazy var textView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.allowsEditingTextAttributes = true
        textview.showsVerticalScrollIndicator = false
        textview.textAlignment = .justified
        textview.autocapitalizationType = .sentences
        textview.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        textview.font = UIFont.preferredFont(forTextStyle: .headline)

        return textview
    }()
    weak var noteDelegate: NoteDelegate?
    private var editIndex: IndexPath?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(moreSee))
        setConstraint()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.isEditable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        noteDelegate?.deliverToPrimary(textView, index: editIndex)
        textView.isEditable = false
    }
    
    func displayData(_ data: Note?, index: IndexPath) {
        guard let textdata = data else {
            textView.text = ""
            
            return
        }
        self.editIndex = index
        textView.isEditable = true
        textView.text = (textdata.title ?? "") + "\n" + (textdata.body ?? "")
        textView.resignFirstResponder()
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    func clearTextView() {
        textView.isEditable = false
        textView.text = ""
    }
 
    @objc private func moreSee() {
        let actionsheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionsheetController.popoverPresentationController?.sourceView = self.view
        let sharedNote = UIAlertAction(title: "Share..", style: .default) { share in
            self.shareNote()
        }
        let deleteNote = UIAlertAction(title: "Delete", style: .destructive) { delete in
            let alertViewController = UIAlertController(title: "Really?", message: "삭제하시겠어요?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                if UITraitCollection.current.horizontalSizeClass == .compact {
                    self.noteDelegate?.backToPrimary()
                }
                let data = NoteManager.shared.specify(self.editIndex)
                NoteManager.shared.delete(data)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertViewController.addAction(delete)
            alertViewController.addAction(cancel)
            
            self.present(alertViewController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionsheetController.addAction(sharedNote)
        actionsheetController.addAction(deleteNote)
        actionsheetController.addAction(cancel)
        
        self.present(actionsheetController, animated: true, completion: nil)
    }
    
    private func shareNote() {
        let shareText = textView.text ?? "새로운 메모"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    private func setConstraint() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.noteDelegate?.deliverToPrimary(textView, index: editIndex)
    }
}
