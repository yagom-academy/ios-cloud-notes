import Foundation
import UIKit

// MARK: UITextViewDelegate
extension MemoContentsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        updateMemo()
        memoTextView.isEditable = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateMemo()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.moveCellToTop.rawValue), object: nil)
    }
}

// MARK: UIGestureRecognizerDelegate
extension MemoContentsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
