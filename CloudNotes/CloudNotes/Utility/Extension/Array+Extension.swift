import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        guard oldIndex != newIndex else { // 두 인덱스가 같으면 탈출
            return
        }
        if abs(newIndex - oldIndex) == 1 { // 절대값을 계산해서 1이라면
            return self.swapAt(oldIndex, newIndex) // 스왑해서 리턴
        }
        self.insert(self.remove(at: oldIndex), at: newIndex) // insert를 이용하네.. 지웠다가 새인덱스에 추가함
    }
}
