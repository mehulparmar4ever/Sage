//
//  CastlingRights.swift
//  Fischer
//
//  Copyright 2016 Nikolai Vazquez
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

/// Castling rights of a `Game`.
///
/// Defines whether a `Color` has the right to castle for a `Board.Side`.
public struct CastlingRights: SetAlgebraType, SequenceType, CustomStringConvertible {

    /// A castling right.
    public enum Right: String, CustomStringConvertible {

        /// White can castle kingside.
        case WhiteKingside

        /// White can castle queenside.
        case WhiteQueenside

        /// Black can castle kingside.
        case BlackKingside

        /// Black can castle queenside.
        case BlackQueenside

        /// All rights.
        public static var all: [Right] {
            return [.WhiteKingside, .WhiteQueenside,
                    .BlackKingside, .BlackQueenside]
        }

        /// The color for `self`.
        public var color: Color {
            get {
                switch self {
                case .WhiteKingside, .WhiteQueenside:
                    return .White
                default:
                    return .Black
                }
            }
            set {
                self = Right(color: newValue, side: side)
            }
        }

        /// The board side for `self`.
        public var side: Board.Side {
            get {
                switch self {
                case .WhiteKingside, .BlackKingside:
                    return .Kingside
                default:
                    return .Queenside
                }
            }
            set {
                self = Right(color: color, side: side)
            }
        }

        /// The squares expected to be empty for a castle.
        public var emptySquares: Bitboard {
            switch self {
            case .WhiteKingside:
                return 0b01100000
            case .WhiteQueenside:
                return 0b00001110
            case .BlackKingside:
                return 0b01100000 << 56
            case .BlackQueenside:
                return 0b00001110 << 56
            }
        }

        /// The castle destination square of a king.
        public var castleSquare: Square {
            switch self {
            case .WhiteKingside:
                return .G1
            case .WhiteQueenside:
                return .C1
            case .BlackKingside:
                return .G8
            case .BlackQueenside:
                return .C8
            }
        }

        /// The character for `self`.
        public var character: Character {
            switch self {
            case .WhiteKingside:
                return "K"
            case .WhiteQueenside:
                return "Q"
            case .BlackKingside:
                return "k"
            case .BlackQueenside:
                return "q"
            }
        }

        /// A textual representation of `self`.
        public var description: String {
            return rawValue
        }

        private var _bit: Int {
            switch self {
            case .WhiteKingside:  return 0b0001
            case .WhiteQueenside: return 0b0010
            case .BlackKingside:  return 0b0100
            case .BlackQueenside: return 0b1000
            }
        }

        /// Create a `Right` from `color` and `side`.
        public init(color: Color, side: Board.Side) {
            switch (color, side) {
            case (.White, .Kingside):
                self = .WhiteKingside
            case (.White, .Queenside):
                self = .WhiteQueenside
            case (.Black, .Kingside):
                self = .BlackKingside
            case (.Black, .Queenside):
                self = .BlackQueenside
            }
        }

        /// Create a `Right` from a `Character`.
        public init?(character: Character) {
            switch character {
            case "K": self = .WhiteKingside
            case "Q": self = .WhiteQueenside
            case "k": self = .BlackKingside
            case "q": self = .BlackQueenside
            default: return nil
            }
        }

    }

    /// A generator over the members of `CastlingRights`.
    public struct Generator: GeneratorType {

        private var _base: SetGenerator<Right>

        /// Advance to the next element and return it, or `nil` if no next element exists.
        public mutating func next() -> Right? {
            return _base.next()
        }

    }

    /// All castling rights.
    public static let all = CastlingRights(Right.all)

    /// The rights.
    private var _rights: Set<Right>

    /// A textual representation of `self`.
    public var description: String {
        if !_rights.isEmpty {
            return String(_rights.map({ $0.character }).sort())
        } else {
            return "-"
        }
    }

    /// Creates empty rights.
    public init() {
        _rights = Set()
    }

    /// Creates a `CastlingRights` from a `String`.
    ///
    /// - Returns: `nil` if `string` is empty or invalid.
    public init?(string: String) {
        guard !string.isEmpty else {
            return nil
        }
        if string == "-" {
            _rights = Set()
        } else {
            var rights = Set<Right>()
            for char in string.characters {
                guard let right = Right(character: char) else {
                    return nil
                }
                rights.insert(right)
            }
            _rights = rights
        }
    }

    /// Creates a set of rights from a sequence.
    public init<S: SequenceType where S.Generator.Element == Right>(_ sequence: S) {
        if let set = sequence as? Set<Right> {
            _rights = set
        } else {
            _rights = Set(sequence)
        }
    }

    /// Returns `true` if `self` contains `member`.
    @warn_unused_result
    public func contains(member: Right) -> Bool {
        return _rights.contains(member)
    }

    /// Returns the set of elements contained in `self`, in `other`, or in both `self` and `other`.
    @warn_unused_result(mutable_variant="unionInPlace")
    public func union(other: CastlingRights) -> CastlingRights {
        return CastlingRights(_rights.union(other._rights))
    }

    /// Returns the set of elements contained in both `self` and `other`.
    @warn_unused_result(mutable_variant="intersectInPlace")
    public func intersect(other: CastlingRights) -> CastlingRights {
        return CastlingRights(_rights.intersect(other._rights))
    }

    /// Returns the set of elements contained in `self` or in `other`, but not in both `self` and `other`.
    @warn_unused_result(mutable_variant="exclusiveOrInPlace")
    public func exclusiveOr(other: CastlingRights) -> CastlingRights {
        return CastlingRights(_rights.exclusiveOr(other._rights))
    }

    /// Insert all elements of `other` into `self`.
    public mutating func unionInPlace(other: CastlingRights) {
        _rights.unionInPlace(other._rights)
    }

    /// Removes all elements of `self` that are not also present in `other`.
    public mutating func intersectInPlace(other: CastlingRights) {
        _rights.intersectInPlace(other._rights)
    }

    /// Replaces `self` with a set containing all elements contained in either `self` or `other`, but not both.
    public mutating func exclusiveOrInPlace(other: CastlingRights) {
        _rights.exclusiveOrInPlace(other._rights)
    }

    /// If `member` is not already contained in `self`, inserts it.
    public mutating func insert(member: Right) {
        _rights.insert(member)
    }

    /// If `member` is contained in `self`, removes and returns it. Otherwise, removes all elements subsumed by `member`
    /// and returns `nil`.
    ///
    /// - Postcondition: `self.intersect([member]).isEmpty`
    public mutating func remove(member: Right) -> Right? {
        return _rights.remove(member)
    }

    /// Returns a generator over the members.
    ///
    /// - Complexity: O(1).
    public func generate() -> Generator {
        return Generator(_base: _rights.generate())
    }

}

extension CastlingRights: Hashable {
    /// The hash value.
    public var hashValue: Int {
        return _rights.reduce(0, combine: { $0 | $1._bit })
    }
}

/// Returns `true` if both have the same rights.
public func == (lhs: CastlingRights, rhs: CastlingRights) -> Bool {
    return lhs._rights == rhs._rights
}
