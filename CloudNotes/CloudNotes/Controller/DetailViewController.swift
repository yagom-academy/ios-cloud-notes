//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/19.
//

import UIKit

protocol DetailViewDelegate: AnyObject {
    func didDeleteMemo()
    func didUpdateMemo()
}

final class DetailViewController: UIViewController {
    
    var index: Int?
    weak var detailViewDelegate: DetailViewDelegate?
    
    var memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setTapGesture()
        setNavigation()
    }
    
    // MARK: - Set Navigation
    private func setNavigation() {
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapEllipsisButton))
    }

    // MARK: - ActionSheet
    @objc private func didTapEllipsisButton() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Share...", style: .default, handler: { _ in
            self.didTapShareButton()
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.didTapCheckDeleteButton()
        }))
        self.present(sheet, animated: true )
    }
    
    private func didTapShareButton() {
        
    }
    
    private func didTapCheckDeleteButton() {
        let alret = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        alret.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alret.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.didTapDeleteButton()
        }))
        self.present(alret, animated: true)
    }
    
    private func didTapDeleteButton() {
        guard let index = index else { return }
        let memo = MemoData.shared.list[index]
        MemoData.shared.delete(memo: memo)
        self.navigationController?.popViewController(animated: false)
        self.detailViewDelegate?.didDeleteMemo()
    }

    private func setTextView() {
        memoTextView.delegate = self
        addSubview()
        setAutoLayout()
    }

    private func addSubview() {
        view.addSubview(memoTextView)
    }

    private func setAutoLayout() {
        let magin: CGFloat = 10
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: magin),
            memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: magin),
            memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -magin),
            memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -magin)
        ])
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        memoTextView.isEditable = false
    }
}

// MARK: - GestureRecognizer
extension DetailViewController {
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedTextView(_:)))
        tapGesture.delegate = self
        memoTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTappedTextView(_ gestrue: UITapGestureRecognizer) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(didTapCompletionOfEditingButton))
        
        guard memoTextView.isEditable == false else {
            return
        }
        
        guard let textView = gestrue.view as? UITextView else {
            return
        }

        let tappedLocation = gestrue.location(in: textView)
        let glyphIndex = textView.layoutManager.glyphIndex(for: tappedLocation, in: textView.textContainer)
        
        if glyphIndex < textView.textStorage.length,
           textView.textStorage.attribute(NSAttributedString.Key.link, at: glyphIndex, effectiveRange: nil) == nil {
            memoTextView.isEditable = true
            placeCursor(textView, tappedLocation)
            memoTextView.becomeFirstResponder()
        }
    }
    
    @objc private func didTapCompletionOfEditingButton() {
        memoTextView.isEditable = false
        guard let index = index else { return }
        let memo = MemoData.shared.list[index]
        let text = memoTextView.text
        MemoData.shared.update(memo: memo, text: text)
        navigationController?.popViewController(animated: false)
        self.detailViewDelegate?.didUpdateMemo()
    }
    
    private func placeCursor(_ textView: UITextView, _ tappedLocation: CGPoint) {
        if let position = textView.closestPosition(to: tappedLocation) {
            let uiTextRange = textView.textRange(from: position, to: position)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let location = textView.offset(from: textView.beginningOfDocument, to: position)
                let length = textView.offset(from: start, to: end)
                textView.selectedRange = NSMakeRange(location, length)
            }
        }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
