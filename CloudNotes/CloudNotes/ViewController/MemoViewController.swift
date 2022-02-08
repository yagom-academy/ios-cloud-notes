import UIKit

final class MemoViewController: UIViewController {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func updateTextView(with memo: Memo) {
        textView.text = memo.body
    }
    
    private func configure() {
        configureMemoView()
        configureNavigationBar()
    }
    
    private func configureMemoView() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "ellipsis.circle")
    }
    
}
