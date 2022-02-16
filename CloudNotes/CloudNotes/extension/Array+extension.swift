import Foundation

extension Array {
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        guard oldIndex != newIndex else {
            return
        }
        if abs(newIndex - oldIndex) == 1 {
            return self.swapAt(oldIndex, newIndex)
        }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
