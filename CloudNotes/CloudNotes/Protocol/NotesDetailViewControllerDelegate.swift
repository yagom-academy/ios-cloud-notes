import Foundation

protocol NotesDetailViewControllerDelegate: AnyObject {
    func updateData(with index: Int)
    func clearTextView()
}
