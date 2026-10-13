// このファイル自体は整理整頓時に消さないこと
import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

/// 棚卸し用の雑多な検証置き場。
final class EtcTests: XCTestCase {

  override func setUpWithError() throws {
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }

  /// FenwickTreeのstorage初期化で使われる非自明なgeneric integer literalの棚卸し候補。
  /// 製品契約の確定後、この言語挙動を実装不変条件として残すか判断する。
  func testInventoryFenwickGenericNegativeOneInitializesUnsignedStorageToZero() {
    func value<U: FixedWidthInteger & UnsignedInteger>(_: U.Type) -> U { -1 }

    XCTAssertEqual(value(UInt32.self), .zero)
    XCTAssertEqual(value(UInt64.self), .zero)
    XCTAssertEqual(value(UInt.self), .zero)

    if #available(macOS 15.0, *) {
      XCTAssertEqual(value(UInt128.self), .zero)
    }
  }
}
