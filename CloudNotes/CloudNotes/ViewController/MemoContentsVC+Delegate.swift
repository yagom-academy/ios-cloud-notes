import Foundation
import UIKit

// MARK: UITextViewDelegate
extension MemoContentsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        memoTextView.isEditable = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateMemo()
        delegate?.moveCellToTop()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.attributedText = makeAttributedString(text: textView.text)
        textView.selectedRange = range
        return true
    }
}

// MARK: UIGestureRecognizerDelegate
extension MemoContentsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
