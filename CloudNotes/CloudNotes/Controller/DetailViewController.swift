//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

final class DetailViewController: UIViewController {
    private var memoIndex: Int?
    private var memoBodyTextView: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
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
    
    //MARK: setup memo
    private func setupMemo(_ index: Int?) {
        self.memoIndex = index
        refreshUI()
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let memoIndex = memoIndex else {
            setDefaultMemo()
            return
        }
        
        if let content =  MemoModel.shared.list[memoIndex].content {
            self.memoBodyTextView.attributedText = applyFontStyle(content: content)
        }
    }
    
    private func setDefaultMemo() {
        MemoModel.shared.create(content: nil)
        self.memoIndex = 0
        self.memoBodyTextView.text = ""
    }
    
    private func applyFontStyle(content: String) -> NSAttributedString {
        let lines = content.split(separator: "\n")
        guard let title = lines.first else {
            return NSAttributedString(string: "")
        }
        let newLineCount = countNewLine(from: content)

        let finalContent = NSMutableAttributedString(string: content)
        finalContent.addAttributes([NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)], range: NSMakeRange(0, title.count + newLineCount))
        finalContent.addAttributes([NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)], range: NSMakeRange(title.count + newLineCount, content.count - title.count - newLineCount))
        
        return finalContent
    }
    
    private func countNewLine(from content: String) -> Int {
        var count = 0
        while content[String.Index(utf16Offset: count, in: content)] == "\n" {
            count += 1
        }
        return count
    }

    //MARK: setup keyboard
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
}

//MARK: - setup text view
extension DetailViewController {
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
}

//MARK: - setup navigation bar & action sheet
extension DetailViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    @objc private func showActionSheet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "공유", style: .default) { [weak self] _ in
            self?.shareMemo()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.showAlert()
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
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deleteMemo()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteMemo() {
        if let memoIndex = self.memoIndex {
            MemoModel.shared.delete(index: memoIndex)
        }
        else {
            MemoModel.shared.delete(index: 0)
        }
        self.memoBodyTextView.text = nil
        self.navigationController?.navigationController?.popViewController(animated: true)
    }
}

//MARK: - extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let memoIndex = memoIndex,
              let content = textView.text else {
            return
        }
        
        if let originalContent = MemoModel.shared.list[memoIndex].content,
           content.elementsEqual(originalContent) {
            return
        }
        
        if content.isEmpty {
            MemoModel.shared.update(index: memoIndex, content: nil)
        } else {
            MemoModel.shared.update(index: memoIndex, content: content)
            self.memoIndex = 0
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.attributedText = applyFontStyle(content: textView.text)
        textView.selectedRange = range
        return true
    }
}

extension DetailViewController: MemoUpdateDelegate {
    func memoSelected(_ memoIndex: Int?) {
        setupMemo(memoIndex)
    }
    func memoDeleted() {
        self.memoBodyTextView.text = nil
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
