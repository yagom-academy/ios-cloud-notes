//
//  NoteDetail.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteDetailViewController: UIViewController {
    private lazy var noteListManager = NoteManager()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(moreSee))
        setConstraint()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.isEditable = true
        self.textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.isEditable = false
    }
    
    func displayData(_ data: Note) {
        if data.title == nil { return }
        textView.text = ""
        textView.insertText(data.title ?? "")
        textView.insertText("\n\n")
        textView.insertText(data.body ?? "")
        textView.resignFirstResponder()
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
 
    @objc private func moreSee() {
        let actionsheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sharedNote = UIAlertAction(title: "Share..", style: .default) { share in
            self.shareNote()
        }
        let deleteNote = UIAlertAction(title: "Delete", style: .destructive) { delete in
            
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
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        noteDelegate?.deliverToPrimary(textView.text)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}
