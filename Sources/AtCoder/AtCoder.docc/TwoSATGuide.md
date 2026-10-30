# 2-SAT

A Swift reference for 2-SAT.

## Swift usage

TwoSAT is noncopyable. Use var for adding clauses and solving. A unit clause x[i] = f is expressed by add_clause(i, f, i, f). Read answer only after a successful satisfiable() call; adding clauses requires solving again before treating the assignment as a solution. The returned Swift Array uses copy-on-write; copying all elements or mutating a shared result costs O(n).

It solves 2-SAT.

For variables `x_0, x_1, …, x_(N - 1)` and clauses with form

- `(x_i = f) ∨ (x_j = g)`,

it decides whether there is a truth assignment that satisfies all clauses.

## Constructor

```swift
var ts = TwoSAT(n)
```

It creates a 2-SAT of `n` variables and `0` clauses.

**Constraints**

- `0 ≤ n ≤ 10^8`

**Complexity**

- `O(n)`

## add_clause

```swift
ts.add_clause(i, f, j, g)
```

It adds a clause `(x_i = f) ∨ (x_j = g)`.

**Constraints**

- `0 ≤ i < n`
- `0 ≤ j < n`

**Complexity**

- `O(1)` amortized

## satisfiable

```swift
let possible: Bool = ts.satisfiable
```

If there is a truth assignment that satisfies all clauses, it returns `true`. Otherwise, it returns `false`.

**Constraints**

- You may call it multiple times.

**Complexity**

- `O(n + m)`, where `m` is the number of added clauses.

## answer

```swift
let values: [Bool] = ts.answer()
```

It returns a truth assignment that satisfies all clauses of the last call of `satisfiable`.
If we call it before calling `satisfiable` or when the last call of `satisfiable` returns `false`, it returns the Array of length `n` with undefined elements.

**Complexity**

- `O(n)`

## Example

```swift
import AtCoder

var formula = TwoSAT(2)
formula.add_clause(0, true, 0, true)
formula.add_clause(0, false, 1, true)
if formula.satisfiable() {
    print(formula.answer()) // [true, true]
}
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/twosat.md), CC0-1.0.
