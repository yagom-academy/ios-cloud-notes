import UIKit

class NoteDetailViewController: UIViewController {
    private var textView: UITextView = {
        let textview = UITextView(frame: .zero)
        textview.font = .preferredFont(forTextStyle: .caption1)
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    override func loadView() {
        view = .init()
        view.backgroundColor = .white
        view.addSubview(textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextViewLayout()
        setUpNavigationItems()
    }
    
    func setUpText(with data: Sample) {
        textView.text = data.body
    }
    
    private func setUpNavigationItems() {
        let circleImage = UIImage(systemName: "ellipsis.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: circleImage,
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    private func setUpTextViewLayout() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
