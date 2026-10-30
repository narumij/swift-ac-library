# Math

A Swift reference for Math.

## Swift usage

All arguments and results use Int; the bit-bound descriptions here assume a 64-bit host. For pow_mod use the original C++ int modulus range (1...Int32.max), not the entire Swift Int range. inv_mod requires coprime inputs. crt requires the least common multiple to fit Int. floor_sum uses unsigned intermediates and returns the 64-bit wrapped result interpreted as Int; negative a and b are allowed. The current source includes the negative-coefficient boundary fix; older deployed versions can give wrong results or trap even when the final answer fits Int.

It contains number-theoretic algorithms.

## pow_mod

```swift
let value: Int = pow_mod(x, n, m)
```

It returns `x^n mod m`.

**Constraints**

- `0 ≤ n`
- `1 ≤ m`

**Complexity**

- `O(log n)`

## inv_mod

```swift
let inverse: Int = inv_mod(x, m)
```

It returns an integer `y` such that `0 ≤ y < m` and  `xy ≡ 1 mod m`.

**Constraints**

- `gcd(x, m) = 1`
- `1 ≤ m`

**Complexity**

- `O(log m)`

## crt

```swift
let result: (rem: Int, mod: Int) = crt(remainders, moduli)
```

Given two arrays `r,m` with length `n`, it solves the modular equation system

`x ≡ r[i] (mod m[i]), i = 0..<n`

If there is no solution, it returns `(0, 0)`. Otherwise, all the solutions can be written as the form `x ≡ y mod z`, using integers
`y, z` `(0 ≤ y < z = (lcm)(m[i]))`. It returns this `(y, z)` as a pair. If `n=0`, it returns `(0, 1)`.

**Constraints**

- `|r| = |m|`
- `1 ≤ m[i]`
- `(lcm)(m[i])` is in `Int64`.

**Complexity**

- `O(n log((lcm)(m[i])))`

## floor_sum

```swift
let total: Int = floor_sum(n, m, a, b)
```

It returns

`Σ(i = 0..<n) floor((a × i + b) / m)`

It returns the answer in `mod 2^64`, if overflowed.

**Constraints**

- `0 ≤ n < 2^(32)`
- `1 ≤ m < 2^(32)`

**Complexity**

- `O(log m)`

## Example

```swift
import AtCoder

print(pow_mod(2, 10, 1_000)) // 24
print(inv_mod(3, 7)) // 5
let solution = crt([2, 3], [3, 5])
print(solution.rem, solution.mod) // 8 15
print(floor_sum(4, 10, 6, 3)) // 3
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/math.md), CC0-1.0.
