import UIKit

final class MemoContentViewController: UIViewController, MemoReloadable {
    weak var selectedMemo: Memo?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainMemoView()
        textView.delegate = self
    }
    
    func reload() {
        guard let currentMemo = selectedMemo else {
            textView.text = nil
            return
        }
        let title = currentMemo.title ?? ""
        let body = currentMemo.body ?? ""
        textView.text = "\(title)\n\(body)"
        let startPosition = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: startPosition, to: startPosition)
    }

    private func setupMainMemoView() {
        configureMemoView()
        configureMemoViewAutoLayout()
        configureNavigationBar()
    }
    
    private func configureMemoView() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureMemoViewAutoLayout() {
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Assets.ellipsisCircleImage,
            style: .plain,
            target: self,
            action: #selector(presentPopover)
        )
    }
}

extension MemoContentViewController {
    @objc func presentPopover(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            self.presentActivityViewController(sender: sender)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presentDeleteAlert()
        }
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.popoverPresentationController?.barButtonItem = sender
        present(alert, animated: true)
    }
    
    private func presentActivityViewController(sender: UIBarButtonItem) {
        guard let memoDetail = textView.text else { return }
        let activityViewController = UIActivityViewController(
            activityItems: [memoDetail],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.barButtonItem = sender
        present(activityViewController, animated: true)
    }
    
    private func presentDeleteAlert() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.deleteMemo()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    private func deleteMemo() {
        guard let currentMemo = selectedMemo else { return }
        CoreDataManager.shared.delete(data: currentMemo)
    }
}

extension MemoContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let memoDetail = textView.text,
              let currentMemo = selectedMemo else { return }
        
        if let firstLineBreakIndex = memoDetail.firstIndex(of: "\n") {
            let title = String(memoDetail[..<firstLineBreakIndex])
            let bodyStartIndex = memoDetail.index(after: firstLineBreakIndex)
            let bodyEndIndex = memoDetail.endIndex
            let body = String(memoDetail[bodyStartIndex..<bodyEndIndex])
            CoreDataManager.shared.update(data: currentMemo, title: title, body: body)
        } else {
            let title = memoDetail
            CoreDataManager.shared.update(data: currentMemo, title: title, body: nil)
        }
    }
}
