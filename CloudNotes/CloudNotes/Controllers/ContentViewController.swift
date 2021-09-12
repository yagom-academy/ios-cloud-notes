//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/05.
//
import UIKit

class ContentViewController: UIViewController {
    // MARK: - Property
    private var textView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .lightGray
        if UITraitCollection.current.userInterfaceIdiom == .phone {
            textView.font = .systemFont(ofSize: 20, weight: .bold)
        } else {
            textView.font = .systemFont(ofSize: 25, weight: .bold)
        }
        return textView
    }()
    var memo: String?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureNavigationBar()
        configureTextView()

        if let navigationController = splitViewController?.viewControllers.first,
           let memoListTableViewController = navigationController.children.first as? MemoListTableViewController {
            memoListTableViewController.delegate = self
        }
    }

}

// MARK: - Method
extension ContentViewController {

    private func configureTextView() {
        view.addSubview(textView)
        textView.setConstraintEqualToAnchor(superView: view)
        textView.text = memo
    }

    private func configureNavigationBar() {
        let itemImage = UIImage(systemName: "ellipsis.circle")
        let rightBarButtonItem = UIBarButtonItem(image: itemImage, style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }
}

// MARK: - CustomDelegate Conform
extension ContentViewController: MemoListTableViewControllerDelegate {
    func didTapMemo(_ vc: UITableViewController, memo: String) {
        textView.text = memo
    }
}
