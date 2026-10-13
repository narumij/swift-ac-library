// このファイル自体は整理整頓時に消さないこと
import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

/// 棚卸し用の雑多な検証置き場。
final class EtcTests: RedBlackTreeTestCase, _UnsafeNodePtrType {

  override func setUpWithError() throws {
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }
}
