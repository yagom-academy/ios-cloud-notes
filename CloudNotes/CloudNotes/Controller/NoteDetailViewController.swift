import UIKit

final class NoteDetailViewController: UIViewController {
    
    private let viewModel: NoteViewModel
    private var identifier: UUID? {
        didSet {
            changeTextViewEditingByIdentifier()
            resetDetailTextView()
        }
    }
    
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
    func detailBarButtonItemDidTap() {
        guard let identifier = identifier else {
            return
        }
        let shareAction = UIAlertAction(title: "share".localized, style: .default) { [self] _ in
            presentActivityView(items: [noteDetailTextView.text ?? ""]) { activityViewController in
                activityViewController.popoverPresentationController?.barButtonItem = detailBarButtonItem
            }
        }
        let deleteAction = UIAlertAction(title: "delete".localized, style: .destructive) { _ in
            self.presentAlert(title: "deleteAlertTitleMessage".localized,
                              message: "deleteAlertBodyMessage".localized) { alert in
                let actions = [
                    UIAlertAction(title: "cancel".localized, style: .cancel),
                    UIAlertAction(title: "delete".localized, style: .destructive) { _ in
                        self.viewModel.deleteNote(identifier: identifier)
                    }]
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
        view.backgroundColor = .secondarySystemBackground
    }
    
    init(viewModel: NoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeTextViewEditingByIdentifier() {
        noteDetailTextView.isEditable = identifier != nil
    }
    
    private func resetDetailTextView() {
        if identifier == nil {
            noteDetailTextView.text = ""
        }
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
        if textView.text == "\n" {
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let identifier = identifier else {
            return
        }
        
        let text = textView.text ?? ""
        let result = text.split(separator: "\n", maxSplits: 1).map { String($0) }
        
        guard result.count >= 1 else { return }
        let title = result[0]
        let body = result.count >= 2 ? result[1] : ""
        
        viewModel.updateNote(identifier: identifier, title: title, body: body)
    }
    
}

extension NoteDetailViewController: NoteTableViewDelegate {
    
    func selectNote(with identifier: UUID?) {
        self.identifier = identifier
        guard let identifier = identifier else {
            return
        }
        let title = viewModel.fetchTitle(identifier: identifier)
        let body = viewModel.fetchBody(identifier: identifier)
        noteDetailTextView.text = "\(title)\n\(body)"
    }
    
}
