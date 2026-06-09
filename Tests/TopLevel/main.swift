import AtCoder

#if !COMPATIBLE_ATCODER_2025
  // トップレベルで以下のよう記述することが出来るかどうか、コンパイルチェック
  enum ExampleA: SegTreeOperator {
    static func op(_ x: Int, _ y: Int) -> Int { x + y }
    static let e: Int = .min
  }

  var example = SegTree<ExampleA>()

  // トップレベルで以下のよう簡潔に記述することが出来ない時期があったので、コンパイルチェック
  enum ExampleB: SegTreeOperation {
    static let op: Op = (+)
    static let e: Int = 0
  }

  var segtreeB = SegTree<ExampleB>()

  enum ExampleC: LazySegTreeOperator {
    static func op(_ x: S, _ y: S) -> S { x + y }
    static let e: Int = 0
    static func mapping(_ x: F, _ y: S) -> S { x + y }
    static func composition(_ x: F, _ y: F) -> F { x + y }
    static let id: Int = 0
  }

  var segtreeC = LazySegTree<ExampleC>()

  enum ExampleD: LazySegTreeOperation {
    static let op: Op = (+)
    static let e: Int = 0
    static let mapping: Mapping = (+)
    static let composition: Composition = (+)
    static let id: Int = 0
  }

  var segtreeD = LazySegTree<ExampleD>()

  // 可能な場合に以下のように書けるようにしたい
  enum ExampleE: LazySegTreeOperator & SegTreeOperator {
    static func op(_ x: S, _ y: S) -> S { x + y }
    static let e: Int = 0
    static func mapping(_ x: F, _ y: S) -> S { x + y }
    static func composition(_ x: F, _ y: F) -> F { x + y }
    static let id: Int = 0
  }

  var segtreeE0 = SegTree<ExampleE>()
  var segtreeE1 = LazySegTree<ExampleE>()

  // 可能な場合に以下のように書けるようにしたい
  enum ExampleF: LazySegTreeOperation & SegTreeOperation {
    static let op: Op = (+)
    static let e: Int = 0
    static let mapping: Mapping = (+)
    static let composition: Composition = (+)
    static let id: Int = 0
  }

  var segtreeF0 = SegTree<ExampleF>()
  var segtreeF1 = LazySegTree<ExampleF>()

  // 可能な場合に以下のように書けるようにしたい
  enum ExampleG: LazySegTreeOperator & SegTreeOperation {
    static let op: Op = (+)
    static let e: Int = 0
    static func mapping(_ x: F, _ y: S) -> S { x + y }
    static func composition(_ x: F, _ y: F) -> F { x + y }
    static let id: Int = 0
  }

  var segtreeG0 = SegTree<ExampleG>()
  var segtreeG1 = LazySegTree<ExampleG>()
#endif
