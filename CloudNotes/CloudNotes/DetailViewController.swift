//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

protocol MemoListUpdateDelegate: class {
    func updateMemo(_ memoIndex: Int)
    func deleteMemo(_ memoIndex: Int)
    func saveMemo(_ memoIndex: Int)
}

final class DetailViewController: UIViewController {
    private var isMemoDeleted: Bool = false
    weak var delegate: MemoListUpdateDelegate?
    private var memoIndex: Int?
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
    
    //MARK: setup memo
    private func setupMemo(_ index: Int?) {
        memoIndex = index
        refreshUI()
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let memoIndex = memoIndex,
              let title = MemoModel.shared.list[memoIndex].title ,
              let body =  MemoModel.shared.list[memoIndex].body else {
            MemoModel.shared.save(title: "새로운메모", body: "아직 내용없음")
            memoBodyTextView.text = ""
            delegate?.saveMemo(0)
            return
        }
        let content = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSAttributedString(string: "\n" + body, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        
        memoBodyTextView.attributedText = content
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

//MARK: setup text view
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

//MARK: setup navigation bar & action sheet
extension DetailViewController {
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
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deleteMemo()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteMemo() {
        self.isMemoDeleted = true
        if let memoIndex = self.memoIndex {
            MemoModel.shared.delete(index: memoIndex)
            self.delegate?.deleteMemo(memoIndex)
        }
        else {
            MemoModel.shared.delete(index: 0)
            self.delegate?.deleteMemo(0)
        }
        self.memoBodyTextView.text = nil
        self.navigationController?.navigationController?.popViewController(animated: true)
    }
}

//MARK: extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let contexts = self.memoBodyTextView.text, !contexts.isEmpty, !isMemoDeleted else {
            self.memoBodyTextView.text = nil
            self.isMemoDeleted = false
            return
        }
        let lines = contexts.split(separator: "\n", maxSplits: 1)
        var title = ""
        var body = ""
        if lines.count > 1 {
            title = String(lines[0])
            body = String(lines[1])
        }
        else {
            title = String(lines[0])
        }
        
        if let memoIndex = memoIndex,
           let originalTitle = MemoModel.shared.list[memoIndex].title,
           let originalBody = MemoModel.shared.list[memoIndex].body {
            if !contexts.elementsEqual(originalTitle + "\n" + originalBody)  {
                MemoModel.shared.update(index: memoIndex, title: title, body: body)
                delegate?.updateMemo(memoIndex)
                self.memoIndex = 0
            }
            else {
                return
            }
        }
        else {
            MemoModel.shared.update(index: 0, title: title, body: body)
            delegate?.updateMemo(0)
        }
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
