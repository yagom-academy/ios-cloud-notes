import XCTest
import CoreData

@testable import CloudNotes
class PersistentDataManagerTests: XCTestCase {
    
    var sut: PersistentDataManager!

    override func setUpWithError() throws {
        sut = PersistentDataManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_create로_생성한데이터를_fetch로_조회할수있다() throws {
        // given
        let identifier = UUID()
        let lastModified = Date()
        
        // when
        try sut?.create(entity: "CDNote") { managedObject in
            [
                "identifier": identifier,
                "title": "제목",
                "body": "내용",
                "lastModified": lastModified
            ].forEach { key, value in
                managedObject.setValue(value, forKey: key)
            }
        }
        
        // then
        let fetchRequest = CDNote.fetchNoteRequest(with: identifier)
        let result = try sut.fetch(request: fetchRequest).first
        
        XCTAssertEqual(result?.identifier, identifier)
        XCTAssertEqual(result?.title, "제목")
        XCTAssertEqual(result?.body, "내용")
        XCTAssertEqual(result?.lastModified, lastModified)
    }
    
    func test_생성된데이터를_update했을때_수정된다() throws {
        // given
        let identifier = UUID()
        let lastModified = Date()
        
        try sut?.create(entity: "CDNote") { managedObject in
            [
                "identifier": identifier,
                "title": "와라랄랄",
                "body": "라랄라",
                "lastModified": lastModified
            ].forEach { key, value in
                managedObject.setValue(value, forKey: key)
            }
        }
        
        // when
        let fetchRequest = CDNote.fetchNoteRequest(with: identifier)
        
        try sut?.update(request: fetchRequest) { managedObject in
            [
                "identifier": identifier,
                "title": "수정된 제목",
                "body": "수정된 내용",
                "lastModified": lastModified
            ].forEach { key, value in
                managedObject.setValue(value, forKey: key)
            }
        }
        
        // then
        let result = try sut.fetch(request: fetchRequest).first
        
        XCTAssertEqual(result?.identifier, identifier)
        XCTAssertEqual(result?.title, "수정된 제목")
        XCTAssertEqual(result?.body, "수정된 내용")
        XCTAssertEqual(result?.lastModified, lastModified)
    }
    
}
