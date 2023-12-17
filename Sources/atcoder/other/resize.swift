import Foundation

extension Array where Element: ExpressibleByIntegerLiteral {
    mutating func resize(_ n: Int) {
        if count > n {
            removeLast(count - n)
        } else {
            reserveCapacity(n)
            let zero: Element = 0
            for _ in 0..<(n - count) {
                append(zero)
            }
        }
    }
}
