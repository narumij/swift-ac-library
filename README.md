# swift-ac-library

English | [日本語](README.ja.md)

A Swift port of the [AC (AtCoder) Library][ac-library], a library for competitive programming on [AtCoder][ac].

[![Swift](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## Notice

[If you are using this for current AtCoder submissions, please use this branch.](https://github.com/narumij/swift-ac-library/tree/release/swift-5.8.1)

- Tags up to `0.0.13` support Swift 5.8.1.

## Official Information

[AtCoder Library (ACL) - AtCoder][acl]

## Related Projects

- [ac-library-csharp] — C# version  
- [ac-library-python] — Python version  
- [ac-library-swift] — Original Swift version  

## Usage

To use `swift-ac-library` with SwiftPM, add the following to your `Package.swift`:

```swift
dependencies: [
  .package(
    url: "https://github.com/narumij/swift-ac-library",
    branch: "compatible/AtCoder/2025"),
],
```

Add it to your build target:

```swift
dependencies: [
  .product(name: "AtCoder", package: "swift-ac-library")
]
```

Import in your source code:

```swift
import AtCoder
```

## Declarations with Underscores

A “declaration with an underscore” refers to any declaration whose fully qualified name contains a component starting with an underscore (`_`).

For example, the following names are technically declared as `public`, but are not considered part of the public API:

- `FooModule.Bar._someMember(value:)` — member with underscore  
- `FooModule._Bar.someMember` — type with underscore  
- `_FooModule.Bar` — module with underscore  
- `FooModule.Bar.init(_value:)` — initializer with underscored parameter  

More generally, compatibility is not guaranteed across the codebase.

These declarations may change as needed, and breaking changes may be introduced.

## License

[CC0]

[ac]: https://atcoder.jp/
[acl]: https://atcoder.jp/posts/517
[ac-library]: https://github.com/atcoder/ac-library
[ac-library-swift]: https://github.com/kyomuei/ac-library-swift
[ac-library-python]: https://github.com/not522/ac-library-python
[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp
[CC0]: https://creativecommons.org/public-domain/cc0/
