//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit

protocol NoteDetailViewDelegate: AnyObject {
    func textViewDidChange(noteInformation: NoteInformation)
    func sharedNoteAction(_ sender: UIBarButtonItem)
    func deleteNoteAction()
}

final class NoteDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let noteDetailScrollView = NoteDetailScrollView()
    weak var delegate: NoteDetailViewDelegate?
    var persistantManager: PersistantManager?
    var currentIndex = 0

    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNoteDetailScrollView()
        addObserverKeyboardNotification()
        noteDetailScrollView.noteDetailTextView.delegate = self
    }
    
    // MARK: - internal Methods
    
    func setupDetailView(index: Int) {
        currentIndex = index
        if let note = persistantManager?.notes[index] {
            noteDetailScrollView.configure(with: note)
            scrollTextViewToVisible()
            view.endEditing(true)
        }
    }
    
    func setupEmptyDetailView() {
        DispatchQueue.main.async {
            self.noteDetailScrollView.isHidden = true
        }
    }
    
    func setupNotEmptyDetailView() {
        DispatchQueue.main.async {
            self.noteDetailScrollView.isHidden = false
        }
    }
    
    // MARK: - private Methods
    
    private func setupNavigation() {
        let seeMoreMenuButtonImage = UIImage(systemName: ImageNames.ellipsisCircleImageName)
        let rightButton = UIBarButtonItem(
          image: seeMoreMenuButtonImage,
          style: .done,
          target: self,
          action: #selector(showPopover(_:))
        )
        navigationItem.setRightBarButton(rightButton, animated: false)
        
    }
    
    private func setupNoteDetailScrollView() {
        noteDetailScrollView.delegate = self
        view.addSubview(noteDetailScrollView)
        noteDetailScrollView.setupConstraint(view: view)
    }
    
    @objc private func showPopover(_ sender: UIBarButtonItem) {
        self.showActionSheet(titles: ("shared", "delete"), targetBarButton: sender) { _ in
            self.delegate?.sharedNoteAction(sender)
        } deleteHandler: { _ in
            self.delegate?.deleteNoteAction()
        }
    }
    
    private func scrollTextViewToVisible() {
        DispatchQueue.main.async { [weak self] in
            if let dateLabelHeight = self?.noteDetailScrollView.lastModifiedDateLabel.frame.height {
                let offset = CGPoint(x: 0, y: dateLabelHeight)
                self?.noteDetailScrollView.setContentOffset(offset, animated: true)
            }
        }
    }
}

// MARK: - ScrollView Delegate

extension NoteDetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let dateLabelHeight = noteDetailScrollView.lastModifiedDateLabel.frame.height

        if scrollView.contentOffset.y < dateLabelHeight {
            targetContentOffset.pointee = CGPoint.zero
        }
    }
}

// MARK: - TextView Delegate

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        var title = ""
        var body = ""
        guard let textViewText = textView.text else {
            return
        }
        if textViewText.contains("\n") {
            let splitedText = textView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
            title = String(splitedText.first ?? "")
            body = String(splitedText.last ?? "")
        } else if textViewText.contains("\n") == false && textViewText.count > 100 {
            title = textViewText.substring(from: 0, to: 99)
            body = textViewText.substring(from: 100, to: textViewText.count - 1)
        } else {
            title = textViewText
        }
        let information = NoteInformation(title: title, content: body, lastModifiedDate: Date().timeIntervalSince1970)
        delegate?.textViewDidChange(noteInformation: information)
    }
    
}

// MARK: - Keyboard

extension NoteDetailViewController {
    private func addObserverKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let info = sender.userInfo else {
            return
        }
        
        let userInfo = info as NSDictionary
        guard let keyboardFrame = userInfo.value(
          forKey: UIResponder.keyboardFrameEndUserInfoKey
        ) as? NSValue else {
            return
        }
        
        let keyboardRect = keyboardFrame.cgRectValue
        noteDetailScrollView.contentInset.bottom = keyboardRect.height
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        noteDetailScrollView.contentInset.bottom = .zero
    }
}
