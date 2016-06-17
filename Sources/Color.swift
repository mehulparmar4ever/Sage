//
//  Color.swift
//  Fischer
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// A chess color.
public enum Color: String, CustomStringConvertible {

    /// White chess color.
    case White

    /// Black chess color.
    case Black

    /// Whether the color is white or not.
    public var isWhite: Bool {
        return self == .White
    }

    /// Whether the color is black or not.
    public var isBlack: Bool {
        return self == .Black
    }

    /// A textual representation of `self`.
    public var description: String {
        return rawValue
    }

    /// The lowercase character for the color. `White` is "w", `Black` is "b".
    public var character: Character {
        return self.isWhite ? "w" : "b"
    }

    /// Create a color from a character of any case.
    public init?(character: Character) {
        switch character {
        case "W", "w": self = .White
        case "B", "b": self = .Black
        default: return nil
        }
    }

    /// Returns the inverse of `self`.
    @warn_unused_result(mutable_variant="invert")
    public func inverse() -> Color {
        switch self {
        case .White: return .Black
        case .Black: return .White
        }
    }

    /// Inverts the color of `self`.
    public mutating func invert() {
        self = inverse()
    }

}
