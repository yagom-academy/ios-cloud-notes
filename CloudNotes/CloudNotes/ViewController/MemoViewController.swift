import UIKit

class MemoViewController: UIViewController {
    var containerView1 = UIView()
    var containerView2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView1 = MemoListTableViewController().view
        containerView2 = MemoContentsViewController().view

        traitCollectionDidChange(traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.horizontalSizeClass {
        case .compact:
            view.addSubview(containerView1)
            containerView1.translatesAutoresizingMaskIntoConstraints = false
            containerView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            containerView1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            containerView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            containerView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//            containerView1.backgroundColor = .yellow
        
        case .regular:
            containerView1.translatesAutoresizingMaskIntoConstraints = false
            containerView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            containerView1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            containerView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            containerView1.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1/3).isActive = true
            containerView1.backgroundColor = .yellow
            
            view.addSubview(containerView2)
            containerView2.translatesAutoresizingMaskIntoConstraints = false
            containerView2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            containerView2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            containerView2.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 2/3).isActive = true
            containerView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
        default:
            break
        }
    }
}

