import UIKit

class NoteDetailViewController: UIViewController {
    
    let noteDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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
    }
    
}

extension NoteDetailViewController: NoteDetailDelegate {
    
    func selectNote(at index: Int) { }

}
