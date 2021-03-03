//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class ContentViewController: UIViewController {
    private let headLinefont = UIFont.boldSystemFont(ofSize: 24)
    private let bodyLinefont = UIFont.systemFont(ofSize: 15)
    private var temporaryMemo = Memo()
    var delegate: MemoStatusDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    private lazy var contentView: MemoTextView = {
        let contentView = MemoTextView()
        contentView.delegate = self
        contentView.backgroundColor = .white
        contentView.isScrollEnabled = false
        contentView.isEditable = false
        contentView.autocorrectionType = .no
        contentView.isUserInteractionEnabled = true
        contentView.dataDetectorTypes = .all
        return contentView
    }()
    
    private lazy var optionButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action:  #selector(didTapOptionButton(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = optionButton
        view.backgroundColor = .white
        setUpConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func didTapMemoItem(with memo: Memo) {
        self.temporaryMemo = memo
        updateUI(with: memo)
    }
}
extension ContentViewController {
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func didTapOptionButton(_ sender: UIBarButtonItem) {
        contentView.endEditing(true)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share...", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            guard let sharingMessage = self.contentView.text else {
                return
            }
            
            let activityViewController = UIActivityViewController(activityItems: [sharingMessage], applicationActivities: nil)
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverPresentationController.permittedArrowDirections = []
            }
            self.present(activityViewController, animated: true, completion: nil)
        })
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            let alertController = UIAlertController(title: "진짜요?", message: "진짜로 삭제하시겠습니까?", preferredStyle: .alert)
            
            let deleteCancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            let deleteCompleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _  in
                if let mainVC = self.splitViewController as? MainViewController {
                    let masterVC = mainVC.masterViewController
                    self.delegate = masterVC
                    self.delegate?.deleteMemo(memo: self.temporaryMemo)
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
            alertController.addAction(deleteCancelAction)
            alertController.addAction(deleteCompleteAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ContentViewController {
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func updateUI(with memo: Memo) {
        let memoAttributedString = NSMutableAttributedString(string: memo.title ?? "")
        let bodyAttributedString = NSMutableAttributedString(string: "\n\(memo.body ?? "")")
        memoAttributedString.addAttribute(.font, value: headLinefont, range: NSRange(location: 0, length: memo.title?.count ?? 0))
        bodyAttributedString.addAttribute(.font, value: bodyLinefont, range: NSRange(location: 0, length: memo.body?.count ?? 0))
        memoAttributedString.append(bodyAttributedString)
        contentView.attributedText = memoAttributedString
        updateTextViewSize()
    }
    
    private func updateTextViewSize() {
        let size = CGSize(width: self.view.frame.width, height: .infinity)
        let rearrangedSize = contentView.sizeThatFits(size)
        
        contentView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = rearrangedSize.height
            }
        }
    }
}

extension ContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewSize()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let headerAttributes: [NSAttributedString.Key: UIFont] = [.font: .boldSystemFont(ofSize: 24)]
        let bodyAttributes: [NSAttributedString.Key: UIFont] = [.font : .systemFont(ofSize: 15)]
        let textAsNSString: NSString = contentView.text as NSString
        let replaced: NSString = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let boldRange: NSRange = replaced.range(of: "\n")
        if boldRange.location <= range.location {
            contentView.typingAttributes = bodyAttributes
        } else {
            contentView.typingAttributes = headerAttributes
        }
        
        return true
    }
}
