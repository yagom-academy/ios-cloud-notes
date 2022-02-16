import XCTest

@testable import CloudNotes
class PersistentDataManagerTests: XCTestCase {
    
    var sut: PersistentDataManager!

    override func setUpWithError() throws {
        sut = PersistentDataManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_Create후_fetch를_이용하여_데이터가_정상적으로_저장되었는지_확인함() throws {
        sut?.create(identifier: UUID(), title: "제목", body: "내용", lastModified: Date())
        
        let result = sut.fetch(request: CDNote.fetchRequest())
        XCTAssertNotEqual([CDNote](), result)
    }
    
}
