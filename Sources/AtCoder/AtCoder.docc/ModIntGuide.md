# Modular arithmetic

Store residues and perform modular arithmetic with fixed or runtime moduli.

## Choose a type

- `modint998244353` is `static_modint<mod_998_244_353>`.
- `modint1000000007` is `static_modint<mod_1_000_000_007>`.
- `modint` is `dynamic_modint<mod_dynamic>`. Call `modint.set_mod(m)` before creating values for the problem. The Swift default is 998244353; do not depend on it when another component may change it.

ModInt is a copyable value. Other algorithms do not require reading this chapter unless you choose a ModInt element type.

## Construction and access

| Swift expression | Meaning | Complexity |
| --- | --- | --- |
| `Mint()` | Zero | O(1) |
| `Mint(value)` | Reduce a signed/unsigned integer or Bool modulo m; the residue is in 0..<m | O(1), for fixed-width inputs |
| `Mint.mod` | Modulus as Int | O(1) |
| `value.val` | Residue as Int | O(1) |
| `value.uval` | Residue as UInt | O(1) |
| `Mint(rawValue: x)` | Store UInt x without reduction; requires 0 ≤ x < m | O(1) |

The `mod`, `val`, and `inv` accessors are properties, not the C++ methods.
Integer literals work: `let x: Mint = 10`. Raw construction is only an optimization for an already normalized residue; using it for an arbitrary integer violates the contract.

## Operators

Unary `+` and `-`, binary `+`, `-`, `*`, `/`, compound assignments
`+=`, `-=`, `*=`, `/=`, and equality `==`, `!=` are available.
Integer operands are supported, for example `1 + x` or `x * 1234`.
Swift has no C++ `++` or `--`; use `x += 1` or `x -= 1`.

Division `a / b` and `a /= b` require gcd(b.val, m) = 1.
Addition, subtraction, multiplication and comparisons take O(1);
division takes O(log m). Values with different static modulus types are
different Swift types; do not mix values made under different settings of the
same dynamic type.

## Powers and inverses

- `x.pow(n)` requires n ≥ 0 and returns x to the nth power in O(log n). An exponent of zero gives one modulo m.
- `x.inv` requires gcd(x.val, m) = 1 and returns the multiplicative inverse in O(log m).
- With a prime modulus, a nonzero residue is invertible. With a composite modulus, nonzero alone is insufficient.

## Other fixed moduli

Define a `static_mod` type with `static var umod: UInt`, then use
`static_modint<YourModulus>`. The original ACL contract is 1 ≤ m ≤ 2×10^9+1000.
The Swift implementation advertises up to UInt32.max; its UInt storage does not
permit an arbitrary 64-bit modulus. Prefer the original range unless using a
separately verified extension.

The default `isPrime` returns true (with a Debug primality assertion).
For a composite modulus, explicitly implement `static let isPrime = false`.
It is not an automatic Release primality detector. Choosing the wrong value
can produce an incorrect inverse.

## Runtime moduli and multiple independent settings

`Mint.set_mod(m)` takes O(1); use 1 ≤ m ≤ 2×10^9+1000 for the original contract.
Do not change a modulus while old residues of that type are still in use.
Each dynamic modulus type owns its own Barrett reduction state:

```swift
enum RuntimeModA: dynamic_mod {
    nonisolated(unsafe) static var bt: barrett = .default
}
enum RuntimeModB: dynamic_mod {
    nonisolated(unsafe) static var bt: barrett = .default
}
typealias MintA = dynamic_modint<RuntimeModA>
typealias MintB = dynamic_modint<RuntimeModB>
MintA.set_mod(11)
MintB.set_mod(13)
```

This state is shared and mutable. `nonisolated(unsafe)` does not synchronize it.
Do not race `set_mod` with construction or arithmetic; use independent types
and external synchronization where needed.

## Version differences

The current source fixes construction from narrow integers such as Int8 when
the modulus does not fit that input type. Older versions may trap even for zero.
For those versions widen first, for example `Mint(Int(smallValue))`.
This is a Swift-port issue, not a restriction of the original C++ constructor.

## Example

```swift
import AtCoder

typealias Mint = modint998244353
let a = Mint(10)
let b = Mint(3)
print((a + b).val) // 13
print((a / b * b).val) // 10
print(b.pow(4).val) // 81
print((b * b.inv).val) // 1

modint.set_mod(11)
let x = modint(10)
print((x + 3).val) // 2

enum Mod17: static_mod {
    static let umod: UInt = 17
}
typealias Mint17 = static_modint<Mod17>
print((Mint17(16) + 2).val) // 1
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/modint.md), CC0-1.0.
