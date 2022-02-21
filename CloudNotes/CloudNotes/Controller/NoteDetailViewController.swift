import UIKit

final class NoteDetailViewController: UIViewController {
    
    private let viewModel: NoteViewModel
    private var identifier: UUID?
    
    private let noteDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var detailBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis.circle")
        let barButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(detailBarButtonItemDidTap))
        return barButtonItem
    }()
    
    @objc
    private func detailBarButtonItemDidTap() {
        guard let identifier = identifier else {
            return
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { [self] _ in
            presentActivityView(items: [noteDetailTextView.text ?? ""]) { activityViewController in
                activityViewController.popoverPresentationController?.barButtonItem = detailBarButtonItem
            }
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presentAlert(title: "진짜요?", message: "정말로 지워요?") { alert in
                let actions = [
                    UIAlertAction(title: "취소", style: .cancel),
                    UIAlertAction(title: "삭제", style: .destructive) { _ in
                        self.viewModel.deleteNote(identifier: identifier)
                    }
                ]
                alert.addAction(actions)
            }
        }
        presentAlert(preferredStyle: .actionSheet) { alertController in
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.barButtonItem = detailBarButtonItem
            alertController.addAction([shareAction, deleteAction])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureDelegate()
    }
    
    init(model: NoteViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(noteDetailTextView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            noteDetailTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            noteDetailTextView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            noteDetailTextView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            noteDetailTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            noteDetailTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            noteDetailTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)])
        
        navigationController?.navigationBar.topItem?.setRightBarButton(detailBarButtonItem, animated: true)
    }
    
    private func configureDelegate() {
        noteDetailTextView.delegate = self
    }
    
}

extension NoteDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "\n\n" {
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let identifier = identifier else {
            return
        }
        
        let text = textView.text ?? ""
        let result = text.split(separator: "\n", maxSplits: 1).map { String($0) }
        
        let title = result[0]
        let body = result.count >= 2 ? result[1] : ""
        
        viewModel.updateNote(identifier: identifier, title: title, body: body)
    }
    
}

extension NoteDetailViewController: NoteListTableViewDelegate {
    
    func selectNote(with identifier: UUID) {
        self.identifier = identifier
        let title = viewModel.fetchTitle(identifier: identifier)
        let body = viewModel.fetchBody(identifier: identifier)
        noteDetailTextView.text = "\(title)\n\(body)"
    }
    
}
