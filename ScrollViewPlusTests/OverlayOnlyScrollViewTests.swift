import XCTest
@testable import ScrollViewPlus

final class OverlayOnlyScrollViewTests: XCTestCase {
    func testBasicInitialization() {
        let scrollView = OverlayOnlyScrollView()

        XCTAssertEqual(scrollView.scrollerStyle, .overlay)

        scrollView.scrollerStyle = .legacy

        XCTAssertEqual(scrollView.scrollerStyle, .overlay)
    }
}
