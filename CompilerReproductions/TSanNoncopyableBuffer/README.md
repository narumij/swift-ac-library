# Swift compiler crash with Thread Sanitizer and a noncopyable buffer wrapper

## Summary

Compiling the standalone [Repro.swift](Repro.swift) with `-sanitize=thread` aborts with `Invalid bitcast` and `Broken module found, compilation aborted!` on the toolchain listed below. Compilation without Thread Sanitizer, and compilation with Address Sanitizer, succeed.

This is a **compile-time failure**, not a linker error or a runtime sanitizer report. The command only emits an object file. No executable, package dependencies, XCTest, or concurrent execution is required.

The reproducer was reduced from `DSU.merge` / `DSU.unite` in swift-ac-library. It retains a noncopyable struct, a computed mutable buffer view, and a compound subscript assignment. This identifies a triggering combination, not the compiler's root cause. The source is covered by this repository's CC0 license.

## Observed environment

Confirmed on October 30, 2026:

```text
swift-driver version: 1.168.6
Apple Swift version 6.4 (swiftlang-6.4.0.34.1 clang-2100.3.34.1)
Target: arm64-apple-macosx27.0.0
```

Other operating systems, architectures, and toolchain versions have not been checked.

## Reproduce

From this directory:

```sh
swiftc -Onone -sanitize=thread -emit-object Repro.swift -o /tmp/tsan-buffer.o
```

Release optimization also reproduces the failure:

```sh
swiftc -O -sanitize=thread -emit-object Repro.swift -o /tmp/tsan-buffer-release.o
```

To run the complete comparison matrix:

```sh
bash reproduce.sh
```

The script preserves compiler output in a new temporary directory and prints its location. It returns a nonzero exit if any compilation fails. It does not execute the generated code or modify the library.

## Expected behavior

The valid source should compile with Thread Sanitizer instrumentation, as it does without instrumentation and with Address Sanitizer.

## Actual behavior

Diagnostic excerpt (temporary register numbers may differ):

```text
Invalid bitcast
<unknown>:0: error: fatal error encountered during compilation; please submit a bug report (https://swift.org/contributing/#reporting-bugs)
<unknown>:0: note: Broken module found, compilation aborted!
```

The full compiler output includes an invalid LLVM instruction of the form `bitcast i64 ... to ptr` and a compiler backtrace. Run the script to collect the complete output for the installed toolchain.

| Flags | Observed result |
| --- | --- |
| `-Onone` | Compilation succeeds |
| `-O` | Compilation succeeds |
| `-Onone -sanitize=address` | Compilation succeeds |
| `-Onone -sanitize=thread` | Compiler aborts: Invalid bitcast |
| `-O -sanitize=thread` | Compiler aborts: Invalid bitcast |

The successful controls establish compilation only; they are not runtime memory-safety tests. This report does not establish which individual language feature is necessary for the crash. The library's separately observed runtime races are outside the scope of this reproducer.
