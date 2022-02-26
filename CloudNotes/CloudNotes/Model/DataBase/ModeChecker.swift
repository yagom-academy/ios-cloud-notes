import Foundation
import Alamofire

enum MemoMode {
    
    case asset
    case coreData
    case dropBox
}

class ModeChecker {
    
    static var currentMode: MemoMode = .coreData
    
    private init() {
        
    }
}
