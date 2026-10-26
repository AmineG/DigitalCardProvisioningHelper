import XCTest
@testable import DigitalCardProvisioningHelper

private class LibraryMock: PassLibraryProtocol {
    var passes: [SecureElementPassInfo] = []
    var watchAllowed: Set<String> = []
    func secureElementPasses() -> [SecureElementPassInfo] { passes }
    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool {
        watchAllowed.contains(primaryAccountIdentifier)
    }
}

final class ProvisioningStatusTests: XCTestCase {
    private func pass(_ suffix: String, deactivated: Bool = false) -> SecureElementPassInfo {
        .init(suffix: suffix, primaryAccountIdentifier: "id-\(suffix)", isDeactivated: deactivated)
    }

    func testNoCards() {
        let status = provisioningStatus(for: [], library: LibraryMock())
        XCTAssertFalse(status.passEntriesAvailable)
        XCTAssertFalse(status.remotePassEntriesAvailable)
    }

    func testCardAbsentFromDevice() {
        let status = provisioningStatus(for: ["1234"], library: LibraryMock())
        XCTAssertTrue(status.passEntriesAvailable)
        XCTAssertFalse(status.remotePassEntriesAvailable)
    }

    func testCardPresentAndWatchAllowed() {
        let lib = LibraryMock()
        lib.passes = [pass("1234")]
        lib.watchAllowed = ["id-1234"]
        let status = provisioningStatus(for: ["1234"], library: lib)
        XCTAssertFalse(status.passEntriesAvailable)
        XCTAssertTrue(status.remotePassEntriesAvailable)
    }

    func testCardPresentAndWatchNotAllowed() {
        let lib = LibraryMock()
        lib.passes = [pass("1234")]
        let status = provisioningStatus(for: ["1234"], library: lib)
        XCTAssertFalse(status.passEntriesAvailable)
        XCTAssertFalse(status.remotePassEntriesAvailable)
    }

    func testDeactivatedCardCanBeAddedAgain() {
        let lib = LibraryMock()
        lib.passes = [pass("1234", deactivated: true)]
        let status = provisioningStatus(for: ["1234"], library: lib)
        XCTAssertTrue(status.passEntriesAvailable)
        XCTAssertFalse(status.remotePassEntriesAvailable)
    }

    func testMixedCards() {
        let lib = LibraryMock()
        lib.passes = [pass("1111")]
        lib.watchAllowed = ["id-1111"]
        let status = provisioningStatus(for: ["1111", "2222"], library: lib)
        XCTAssertTrue(status.passEntriesAvailable)
        XCTAssertTrue(status.remotePassEntriesAvailable)
    }

    func testActivePassWinsOverDeactivatedDuplicate() {
        let lib = LibraryMock()
        lib.passes = [pass("1234", deactivated: true), pass("1234")]
        let status = provisioningStatus(for: ["1234"], library: lib)
        XCTAssertFalse(status.passEntriesAvailable)
    }

    func testRequiresAuthenticationIsPropagated() {
        let status = provisioningStatus(for: [], requiresAuthentication: true, library: LibraryMock())
        XCTAssertTrue(status.requiresAuthentication)
    }

    func testRespondsUnder100ms() {
        let lib = LibraryMock()
        lib.passes = (0..<5_000).map { pass(String($0)) }
        let cards = (0..<5_000).map { String($0 + 2_500) }

        let start = ContinuousClock.now
        _ = provisioningStatus(for: cards, library: lib)
        XCTAssertLessThan(start.duration(to: .now), .milliseconds(100))
    }
}
