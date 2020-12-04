import XCTest
@testable import SwiftProgressBar

final class ProgressBarTests: XCTestCase {
    
    var progressBar: ProgressBar!
    var buffer: StringBuffer!
    
    override func setUp() {
        super.setUp()
        buffer = StringBuffer()
        progressBar = ProgressBar(output: buffer)
    }
    
    func testEmpty() {
        progressBar.render(count: 0, total: 100)
        XCTAssertEqual(buffer.string,
        "[------------------------------------------------------------] 0%")
    }
    
    func testFull() {
        progressBar.render(count: 100, total: 100)
        XCTAssertEqual(buffer.string,
        "[🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢] 100%")
    }
    
    func testPartial() {
        progressBar.render(count: 43, total: 100)
        XCTAssertEqual(buffer.string,
        "[🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢-----------------------------------] 43%")
    }

    static var allTests = [
        ("testEmpty", testEmpty),
        ("testFull", testFull),
        ("testPartial", testPartial),
    ]
}
