import UIKit

protocol TypeNameConvertible: AnyObject {
    
    static var reuseIdentifier: String { get }
    
}

extension TypeNameConvertible where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
