//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

protocol MemoListUpdateDelegate: class {
    func deleteMemo(_ memoIndex: Int)
    func saveMemo(_ memoIndex: Int)
}

final class DetailViewController: UIViewController {
    private var isMemoDeleted: Bool = false
    weak var delegate: MemoListUpdateDelegate?
    private var memoIndex: Int? {
        didSet {
            refreshUI()
            memoBodyTextView.isEditable = false
        }
    }
    
    private var memoBodyTextView: UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextView()
        setupNavigationBar()
        setupKeyboardDoneButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    @objc private func showActionSheet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "Share", style: .default) { _ in
            self.shareMemo()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showAlert()
        }
        
        alert.addAction(share)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        if traitCollection.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        }
        else {
            alert.popoverPresentationController?.barButtonItem = sender
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func shareMemo() {
        var memoToShare = [String]()
        if let text = self.memoBodyTextView.text {
            memoToShare.append(text)
        }
        let activityViewController = UIActivityViewController(activityItems: memoToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if let memoIndex = self.memoIndex {
                self.isMemoDeleted = true
                MemoModel.shared.delete(index: memoIndex)
                self.delegate?.deleteMemo(memoIndex)
                self.navigationController?.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupTextView() {
        setTapGesture()
        memoBodyTextView.delegate = self
        memoBodyTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoBodyTextView)
        NSLayoutConstraint.activate([
            memoBodyTextView.topAnchor.constraint(equalTo: view.topAnchor),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoBodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView(_:)))
        tapGesture.delegate = self
        memoBodyTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        if memoBodyTextView.isEditable {
            return
        }
        
        guard let textView = gesture.view as? UITextView else {
            return
        }
        
        let tappedLocation = gesture.location(in: textView)
        let glyphIndex = textView.layoutManager.glyphIndex(for: tappedLocation, in: textView.textContainer)
        
        if glyphIndex >= textView.textStorage.length {
            memoBodyTextView.isEditable = true
        }
        
        if glyphIndex < textView.textStorage.length,
           textView.textStorage.attribute(NSAttributedString.Key.link, at: glyphIndex, effectiveRange: nil) == nil {
            memoBodyTextView.isEditable = true
            placeCursor(textView, tappedLocation)
            memoBodyTextView.becomeFirstResponder()
        }
    }
    
    private func placeCursor(_ textView: UITextView, _ tappedLocation: CGPoint) {
        if let position = textView.closestPosition(to: tappedLocation) {
            let uiTextRange = textView.textRange(from: position, to: position)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let loc = textView.offset(from: textView.beginningOfDocument, to: position)
                let length = textView.offset(from: start, to: end)
                textView.selectedRange = NSMakeRange(loc, length)
            }
        }
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let memoIndex = memoIndex,
              let title = MemoModel.shared.list[memoIndex].title ,
              let body =  MemoModel.shared.list[memoIndex].body else {
            return
        }
        let content = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSAttributedString(string: "\n" + body, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        
        memoBodyTextView.attributedText = content
    }
    
    private func setupKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.doneButtonClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = .systemBlue
        
        memoBodyTextView.inputAccessoryView = toolBarKeyboard
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.memoBodyTextView.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let contexts = self.memoBodyTextView.text, !contexts.isEmpty, !isMemoDeleted else {
            self.memoBodyTextView.text = nil
            self.isMemoDeleted = false
            return
        }
        let lines = contexts.split(separator: "\n", maxSplits: 1)
        var title = ""
        var body = ""
        if lines.count > 0 {
            title = String(lines[0])
            body = String(lines[1])
        }
        
        MemoModel.shared.save(title: title, body: body)
        memoBodyTextView.text = nil
    }
}

//MARK: extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
    }
}

extension DetailViewController: MemoSelectionDelegate {
    func memoSelected(_ memoIndex: Int) {
        self.memoIndex = memoIndex
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
