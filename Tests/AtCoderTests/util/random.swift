import Foundation

func randint(_ a: Int, _ b: Int) -> Int {
  (a...b).randomElement()!
}

func randbool() -> Bool {
  [false, true].randomElement()!
}

func randpair(_ lower: Int, _ upper: Int) -> (Int, Int) {
  assert(upper - lower >= 1)
  while true {
    let (x, y) = (randint(lower, upper), randint(lower, upper))
    guard x == y else { return x < y ? (x, y) : (y, x) }
  }
}
