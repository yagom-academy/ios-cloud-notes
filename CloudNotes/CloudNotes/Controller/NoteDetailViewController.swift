import UIKit

class NoteDetailViewController: UIViewController {
    
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
    
    private let detailBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis.circle")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(noteDetailTextView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            noteDetailTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            noteDetailTextView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            noteDetailTextView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
            noteDetailTextView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor),
            noteDetailTextView.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor),
            noteDetailTextView.trailingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.trailingAnchor)])
        
        self.navigationController?.navigationBar.topItem?.setRightBarButton(detailBarButtonItem, animated: true)
    }
    
}

extension NoteDetailViewController: NoteDetailDelegate {
    
    func selectNote(title: String, body: String) {
        self.noteDetailTextView.text = "\(title)\n\n\(body)"
    }

}
