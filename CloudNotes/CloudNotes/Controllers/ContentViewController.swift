//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/05.
//

import UIKit

class ContentViewController: UIViewController {

    var body: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        configureNavigationBar()
        applyAdaptiveLayoutByDevice(textView: configureTextView)

    }

    @discardableResult
    func configureTextView() -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.lightGray
        view.addSubview(textView)
        textView.setConstraintEqualToAnchor(view: self.view)
        return textView
    }

    func applyAdaptiveLayoutByDevice(textView: () -> UITextView) {
        if UITraitCollection.current.userInterfaceIdiom == .phone {
            textView().font = UIFont.systemFont(ofSize: 20, weight: .bold)
        } else {
            textView().font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
    }

    func configureNavigationBar() {
        let itemImage = UIImage(systemName: "ellipsis.circle")
        let rightBarButtonItem = UIBarButtonItem(image: itemImage, style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }

}

extension UIView {
    func setConstraintEqualToAnchor(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let margin = view.layoutMarginsGuide
        let top = self.topAnchor.constraint(equalTo: margin.topAnchor)
        let leading = self.leadingAnchor.constraint(equalTo: margin.leadingAnchor)
        let trailng = self.trailingAnchor.constraint(equalTo: margin.trailingAnchor)
        let bottom = self.bottomAnchor.constraint(equalTo: margin.bottomAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailng, bottom
        ])
    }
}
