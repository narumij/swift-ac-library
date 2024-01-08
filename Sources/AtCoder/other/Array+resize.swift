import Foundation

extension Array where Element: AdditiveArithmetic {
    mutating func resize(_ n: Int) {
        if count > n {
            removeLast(count - n)
        } else {
            reserveCapacity(n)
            for _ in 0..<(n - count) {
                append(.zero)
            }
        }
    }
}
