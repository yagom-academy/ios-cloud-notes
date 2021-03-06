import UIKit
import CoreData
import Foundation

class MemoContentsViewController: UIViewController {
    weak var delegate: TableViewListManagable?
    lazy var disclosureBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showActionSheet))
    lazy var finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(endEditing))
    
    var memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.adjustsFontForContentSizeCategory = true
        textView.dataDetectorTypes = .all
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.tintColor = UIColor(named: "TextColor")
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMemoContentsView()
        configureAutoLayout()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isCellSelected.rawValue)
    }
    
    // MARK: Configure UI
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItems = [disclosureBarButton]
    }
    
    private func configureMemoContentsView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        tapGesture.delegate = self
        
        memoTextView.delegate = self
        memoTextView.isEditable = false
        memoTextView.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(memoTextView)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: Feature
    func receiveText(memo: NSManagedObject) {
        let content = memo.value(forKey: "content") as? String ?? ""
        memoTextView.attributedText = makeAttributedString(text: content)
    }
    
    @objc func endEditing(_ sender: UIButton) {
        memoTextView.resignFirstResponder()
        navigationItem.rightBarButtonItems?.removeFirst()
        updateMemo()
    }
    
    func deleteMemo() {
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        
        do {
            try delegate?.deleteCell(at: selectedMemoIndexPathRow)
            
            switch splitViewController?.traitCollection.horizontalSizeClass {
            case .compact:
                if let naviController = splitViewController?.viewControllers[0] as? UINavigationController {
                    naviController.popViewController(animated: true)
                }
            default:
                if !(CoreDataSingleton.shared.memoData.isEmpty) {
                    self.receiveText(memo: CoreDataSingleton.shared.memoData[0])
                } else {
                    self.splitViewController?.viewControllers.removeLast()
                }
            }
        } catch {
            showAlertMessage("메모 삭제에 실패했습니다.")
        }
    }
    
    func updateMemo() {
        let text = memoTextView.text ?? ""
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        
        do {
            try CoreDataSingleton.shared.update(object: CoreDataSingleton.shared.memoData[selectedMemoIndexPathRow], content: text)
            delegate?.updateTableViewList()
        } catch {
            showAlertMessage("메모 편집에 실패했습니다.")
        }
    }
    
    func countEnter(text: String) -> Int {
        var enterCount = 0
        let stringArray = text.map { String($0) }
        for charactor in stringArray {
            if charactor == "\n" {
                enterCount += 1
            } else {
                break
            }
        }

        return enterCount
    }
    
    func makeAttributedString(text: String)  -> NSAttributedString  {
        let attributedText = NSMutableAttributedString(string: text)
        let splitedString = text.split(separator: "\n")
        let titleFontSize = UIFont.preferredFont(forTextStyle: .largeTitle)
        let bodyFontSize = UIFont.preferredFont(forTextStyle: .body)
        let textColor = UIColor(named: "TextColor") ?? .gray
        let enterCount = countEnter(text: text)
        
        guard let title = splitedString.first else {
            attributedText.addAttributes([.font: titleFontSize, .foregroundColor: textColor], range: NSRange(location: 0, length: text.count))
            return attributedText
        }
        
        let titleCount = title.count + enterCount
        let bodyCount = text.count - titleCount
        
        attributedText.addAttributes([.font: titleFontSize, .foregroundColor: textColor], range: NSRange(location: 0, length: titleCount))
        attributedText.addAttributes([.font: bodyFontSize, .foregroundColor: textColor], range: NSRange(location: titleCount, length: bodyCount))
        
        return attributedText
    }
}

// MARK: dataDetectorTypes & isEditable
extension MemoContentsViewController {
    @objc func textViewDidTapped(_ recognizer: UITapGestureRecognizer) {
        if memoTextView.isEditable { return }
        
        guard let textView = recognizer.view as? UITextView else {
            return
        }
        let tappedLocation = recognizer.location(in: textView)
        let glyphIndex = textView.layoutManager.glyphIndex(for: tappedLocation, in: textView.textContainer)
        
        if glyphIndex < textView.textStorage.length,
           textView.textStorage.attribute(NSAttributedString.Key.link, at: glyphIndex, effectiveRange: nil) == nil {
            placeCursor(textView, tappedLocation)
            makeTextViewEditable()
            
            navigationItem.rightBarButtonItems?.insert(finishButton, at: 0)
        }
        
        if glyphIndex >= textView.textStorage.length {
            makeTextViewEditable()
        }
    }
    
    private func placeCursor(_ myTextView: UITextView, _ location: CGPoint) {
        if let tapPosition = myTextView.closestPosition(to: location) {
            let uiTextRange = myTextView.textRange(from: tapPosition, to: tapPosition)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let loc = myTextView.offset(from: myTextView.beginningOfDocument, to: tapPosition)
                let length = myTextView.offset(from: start, to: end)
                myTextView.selectedRange = NSMakeRange(loc, length)
            }
        }
    }
    
    private func makeTextViewEditable() {
        memoTextView.isEditable = true
        memoTextView.becomeFirstResponder()
    }
}

// MARK: Alert & ActivityVC
extension MemoContentsViewController {
    private func showAlertMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteMessage() {
        let deleteMenu = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: UIAlertController.Style.alert)
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.deleteMemo()
        }
        deleteMenu.addAction(cancleAction)
        deleteMenu.addAction(deleteAction)
        
        present(deleteMenu, animated: true, completion: nil)
    }
    
    @objc func showActionSheet(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showActivityView(memo: CoreDataSingleton.shared.memoData[0])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            _ in self.showDeleteMessage()
        }
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        actionSheet.popoverPresentationController?.barButtonItem = sender
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showActivityView(memo: NSManagedObject) {
        guard let content: String = memo.value(forKey: "content") as? String else {
            return
        }
        let memoToShare = [content]
        let activityViewController = UIActivityViewController(activityItems: memoToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?.first
        self.present(activityViewController, animated: true, completion: nil)
    }
}
