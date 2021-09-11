//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/05.
//
import UIKit

class ContentViewController: UIViewController {
    // MARK: - Property
    private var textView: UITextView?
    var memo: String?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureNavigationBar()
        applyAdaptiveLayoutByDevice(textView: configureTextView)

        if let memoListTableViewController = splitViewController?.viewControllers.first?.children.first as? MemoListTableViewController {
            memoListTableViewController.delegate = self
        }
    }

}

// MARK: - Method
extension ContentViewController {
    @discardableResult
    private func configureTextView() -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.lightGray
        view.addSubview(textView)
        textView.setConstraintEqualToAnchor(view: self.view)
        textView.text = memo
        return textView
    }

    private func applyAdaptiveLayoutByDevice(textView: () -> UITextView) {
        if UITraitCollection.current.userInterfaceIdiom == .phone {
            textView().font = UIFont.systemFont(ofSize: 20, weight: .bold)
        } else {
            textView().font = UIFont.systemFont(ofSize: 25, weight: .bold)
        }
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
        textView?.text = memo
    }
}
