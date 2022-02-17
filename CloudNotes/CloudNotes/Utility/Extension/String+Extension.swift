import Foundation

extension String {
    var firstLineBreak: Int {
        var index = 0
        for (offset, body) in Array(self).enumerated() {
            if body == "\n" {
                index = offset
                break
            }
        }
        
        return index
    }
}
