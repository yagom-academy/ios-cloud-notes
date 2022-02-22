import UIKit

extension UITableViewController {
  func setBackgroundView(with message: String) {
    let backgroundView = UIView()
    let messageLabel = UILabel()
    messageLabel.text = message
    messageLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    messageLabel.textColor = .placeholderText
    backgroundView.addSubview(messageLabel)

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.centerXAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerYAnchor)
    ])

    tableView.backgroundView = backgroundView
  }
}
