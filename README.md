# swift-ac-library

English | [日本語](README.ja.md)

A Swift port of [AC(AtCoder) Library][ac-library], the competitive programming library for [AtCoder][ac].

[![Swift](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## Official Information

[AtCoder Library (ACL) - AtCoder][acl]

## Usage

To use swift-ac-library with SwiftPM, add the following to your `Package.swift`:

```swift
dependencies: [
  .package(
    url: "https://github.com/narumij/swift-ac-library",
    branch: "compatible/AtCoder/2025"),
],
```

Then add the following dependency to your build target:

```swift
  dependencies: [
    .product(name: "AtCoder", package: "swift-ac-library")
    ]
```

Add the following import to your source code:

```swift
import AtCoder
```

## Branch Strategy

| Branch | Recommended | Description |
|----------|----------|----------|
| `compatible/AtCoder/2025` | ⭐ | Recommended branch compatible with AtCoder 2025 |
| `release/AtCoder/2025` | | Branch matching the version installed on AtCoder 2025 |
| `main` | | Development branch |

### Which branch should I use?

In general, `compatible/AtCoder/2025` is recommended.

The `compatible/AtCoder/2025` branch maintains compatibility with AtCoder 2025 while adding maintenance updates such as documentation improvements, deprecation annotations, and additional notices.

`release/AtCoder/2025` preserves the exact state installed on AtCoder.

`main` is the development branch. APIs and implementations may change.

---

## Declarations with Underscores

A declaration with an underscore is any declaration whose fully qualified name contains a component that starts with an underscore (`_`). For example, the following names are technically declared as `public`, but they are not part of the public API:

- `FooModule.Bar._someMember(value:)` (member with an underscore)
- `FooModule._Bar.someMember` (type with an underscore)
- `_FooModule.Bar` (module with an underscore)
- `FooModule.Bar.init(_value:)` (initializer with an underscored argument)

Do not expect compatibility guarantees for the overall codebase around these declarations. They may be changed as needed, including incompatible changes.

## Related Projects

[ac-library-csharp] - C# version

[ac-library-python] - Python version

[ac-library-swift] - Original Swift version

## License

[CC0]



[ac]: https://atcoder.jp/

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/
