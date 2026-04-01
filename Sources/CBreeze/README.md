# CBreeze

CBreeze is a lightweight bridge target that simplifies C interoperability in the ComputeDHT Swift package.

It has two main responsibilities:

1. Expose the appropriate C runtime for each OS
2. Convert Swift `String` values to C strings (`char *`)

## Purpose

When calling low-level C APIs from Swift, platform-specific imports and pointer conversions tend to be repetitive.
CBreeze centralizes that common interoperability logic so other modules can stay focused on business logic.

## Files

- `COperatingSystem.swift`
	- Exports `Glibc` on Linux
	- Exports `Darwin.C` on macOS
	- Uses `@_exported import`, so importing `CBreeze` also makes C runtime symbols available
- `Cstring.swift`
	- Provides utility functions to convert Swift strings into `UnsafeMutablePointer<Int8>`

## Public API

### `unsafeCStr(from:)`

```swift
public func unsafeCStr(from str: String) -> UnsafeMutablePointer<Int8>
```

Converts a Swift string into a mutable C string pointer.

- Internally calls `toCStr(from:)` using `try!`
- Intended for call sites where conversion failure can be treated as fatal

### `toCStr(from:)`

```swift
public func toCStr(from str: String) throws -> UnsafeMutablePointer<Int8>
```

Converts a Swift string into a mutable C string pointer and throws on failure.

- Allocates memory for UTF-8 bytes plus the null terminator
- Initializes the allocated buffer with `utf8CString` contents

## Usage

```swift
import CBreeze

let ptr = try toCStr(from: "hello")
// Pass ptr to a C API here
ptr.deallocate() // Important: the caller owns this memory
```

For a non-throwing call site:

```swift
import CBreeze

let ptr = unsafeCStr(from: "hello")
// Pass ptr to a C API here
ptr.deallocate()
```

## Memory Management Notes

Both conversion functions allocate heap memory and return raw pointers.
The caller is responsible for releasing the returned pointer with `deallocate()`.

Because `unsafeCStr(from:)` uses `try!`, `toCStr(from:)` is recommended where explicit error handling is required.

## Supported Platforms

- Linux: `Glibc`
- macOS: `Darwin.C`

## Position in Package.swift

In this repository, CBreeze is defined as a SwiftPM target and is used by internal targets such as `CoreOverlay`.

```swift
.target(
		name: "CBreeze",
		exclude: ["README.md"]
)
```

