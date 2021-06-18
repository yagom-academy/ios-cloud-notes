//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/03.
//

import UIKit
import Foundation

final class NoteDetailViewController: UIViewController {
    var noteTextViewModel: NoteTextViewModel?
    var indexPath: IndexPath?
    
    private lazy var detailNoteTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        setBackGroundColor(of: textView)
        textView.contentOffset = CGPoint(x: -20, y: -20)
        textView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailNoteTextView.delegate = self
        self.detailNoteTextView.isEditable = false
        view.backgroundColor = .systemBackground
        setNavigaitonItem()
        setConstraint()
        
        noteTextViewModel?.noteData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.configureTextView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        detailNoteTextView.isEditable = true
        detailNoteTextView.contentOffset = CGPoint(x: -20, y: -20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        detailNoteTextView.isEditable = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.horizontalSizeClass == .regular {
            detailNoteTextView.backgroundColor = .systemBackground
        }
        else if self.traitCollection.horizontalSizeClass == .compact {
            detailNoteTextView.backgroundColor = .systemGray3
        }
    }
    
    private func setNavigaitonItem() {
        let finishButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapFinishButton))
        let moreButton = UIBarButtonItem(image: UIImage(systemName: NoteLiteral.moreButtonImageName), style: .plain, target: self, action: #selector(didTapMoreButton))
        self.navigationItem.rightBarButtonItems = [finishButton, moreButton]
    }
    
    private func setBackGroundColor(of textView: UITextView) {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            textView.backgroundColor = .systemGray3
        }
        else if UITraitCollection.current.horizontalSizeClass == .regular {
            textView.backgroundColor = .systemBackground
        }
    }
    
    private func setConstraint() {
        detailNoteTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailNoteTextView)
        
        NSLayoutConstraint.activate([
            detailNoteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailNoteTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailNoteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailNoteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTextView() {
        self.detailNoteTextView.text = self.noteTextViewModel?.getTextViewData()
    }
    
    @objc private func didTapMoreButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: NoteLiteral.shareTitle, style: .default) { action in
            let shareNote: [Any] = [self.noteTextViewModel?.getTextViewData() as Any]
            let activityViewController = UIActivityViewController(activityItems: shareNote, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: NoteLiteral.deleteTitle, style: .destructive) { action in
            self.showDeleteAlert { action in
                NotificationCenter.default.post(name: UITableView.selectionDidChangeNotification, object: self.indexPath)
                self.cleanup()
            }
        }
        let cancelAction = UIAlertAction(title: NoteLiteral.cancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad, let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            self.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func didTapFinishButton() {
        self.view.endEditing(true)
        if detailNoteTextView.text == NoteLiteral.empty {
            NotificationCenter.default.post(name: UITableView.selectionDidChangeNotification, object: self.indexPath)
        }
    }
    
    private func showDeleteAlert(deleteHandler: @escaping (UIAlertAction) -> Void) {
        let deleteAlert = UIAlertController(title: nil, message: NoteLiteral.deleteMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NoteLiteral.cancelTitle, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: NoteLiteral.deleteTitle, style: .destructive, handler: deleteHandler)
        
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    private func cleanup() {
        self.detailNoteTextView.text = NoteLiteral.empty
        self.detailNoteTextView.isEditable = false
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let noteInfo = (textView.text, Date(), indexPath) as (note: String?, lastModifiedDate: Date?, indexPath: IndexPath?)
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: noteInfo)
    }
}
