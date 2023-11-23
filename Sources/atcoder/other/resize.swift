import Foundation

extension Array where Element: ExpressibleByIntegerLiteral {
    mutating func resize(_ n: Int) {
        if count > n {
            removeLast(count - n)
        } else {
            append(contentsOf: repeatElement(0, count: n - count))
        }
    }
}
