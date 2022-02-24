import Foundation

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
