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

final class MemoModeChanger {
    func switchMode(to mode: MemoMode) {
        ModeChecker.currentMode = mode
    }
    
    func factoryDataManager(mode: MemoMode) -> DataProvider {
        switch mode {
        case .asset:
            return AssetDataManager()
        case .coreData:
            return CoreDataManager<CDMemo>()
        case .dropBox:
            return DropBoxManager()
        }
    }
}
