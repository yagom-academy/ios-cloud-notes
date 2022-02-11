import UIKit

final class MemoContentViewController: UIViewController {
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
    }
    
    func updateTextView(with memo: Memo) {
        textView.text = memo.body
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
            action: #selector(deleteMemo)
            )
    }
}

extension MemoContentViewController {
    @objc func deleteMemo() {
        let context = AppDelegate.persistentContainer.viewContext
        guard let currentMemo = selectedMemo else { return }
        context.delete(currentMemo)
        do {
            try context.save()
            reloadMemoList()
            textView.text = nil
            self.selectedMemo = nil
        } catch {
            print(error)
        }
    }
    
    private func reloadMemoList() {
        guard let splitViewController = splitViewController as? MainSplitViewController else { return }
        splitViewController.reloadMemoList()
    }
}
