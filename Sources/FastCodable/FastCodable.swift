//
//  FastCodable.swift
//
//  Created by Bryce Cogswell on 4/1/23.
//  Copyright © 2023 Bryce Cogswell. All rights reserved.
//

import Foundation

public typealias FastCodable = FastEncodable & FastDecodable

extension Optional: FastCodable where Wrapped: FastCodable {
	public func fastEncode(to encoder: FastEncoder) {
		switch self {
		case let .some(wrapped):
			true.fastEncode(to: encoder)
			wrapped.fastEncode(to: encoder)
		case .none:
			false.fastEncode(to: encoder)
		}
	}

	public init(fromFast decoder: FastDecoder) throws {
		let present = try Bool(fromFast: decoder)
		if present {
			self = .some(try Wrapped(fromFast: decoder))
		} else {
			self = .none
		}
	}
}

extension Array: FastCodable where Element: FastCodable {
	public func fastEncode(to encoder: FastEncoder) {
		UInt32(count).fastEncode(to: encoder)
		for element in self {
			element.fastEncode(to: encoder)
		}
	}

	public init(fromFast decoder: FastDecoder) throws {
		self.init()
		let count = try UInt32(fromFast: decoder)
		reserveCapacity(Int(count))
		for _ in 0..<count {
			let decoded = try Element(fromFast: decoder)
			append(decoded)
		}
	}
}

extension Dictionary: FastCodable where Key: FastCodable, Value: FastCodable {
	public func fastEncode(to encoder: FastEncoder) {
		count.fastEncode(to: encoder)
		for element in self {
			element.key.fastEncode(to: encoder)
			element.value.fastEncode(to: encoder)
		}
	}

	public init(fromFast decoder: FastDecoder) throws {
		self.init()
		let count = try Int(fromFast: decoder)
		reserveCapacity(count)
		for _ in 0..<count {
			let key = try Key(fromFast: decoder)
			let value = try Value(fromFast: decoder)
			self[key] = value
		}
	}
}

extension String: FastCodable {
	public func fastEncode(to encoder: FastEncoder) {
		Array(utf8).fastEncode(to: encoder)
	}

	public init(fromFast decoder: FastDecoder) throws {
		let utf8: [UInt8] = try Array(fromFast: decoder)
		if let str = String(bytes: utf8, encoding: .utf8) {
			self = str
		} else {
			throw FastDecoder.Error.invalidUTF8(utf8)
		}
	}
}

extension Bool: FastCodable {
	public func fastEncode(to encoder: FastEncoder) {
		UInt8(self ? 1 : 0).fastEncode(to: encoder)
	}

	public init(fromFast decoder: FastDecoder) throws {
		let v = try UInt8(fromFast: decoder)
		self = v != 0
	}
}

public extension FixedWidthInteger where Self: FastEncodable {
	func fastEncode(to encoder: FastEncoder) {
		encoder.appendBytes(of: self)
	}

	init(fromFast decoder: FastDecoder) throws {
		var v = Self()
		try decoder.readBytes(into: &v)
		self.init(v)
	}
}

extension Int: FastCodable {}
extension UInt: FastCodable {}
extension Int8: FastCodable {}
extension UInt8: FastCodable {}
extension Int16: FastCodable {}
extension UInt16: FastCodable {}
extension Int32: FastCodable {}
extension UInt32: FastCodable {}
extension Int64: FastCodable {}
extension UInt64: FastCodable {}

extension Double: FastCodable {
	public func fastEncode(to encoder: FastEncoder) {
		encoder.appendBytes(of: self)
	}

	public init(fromFast decoder: FastDecoder) throws {
		var v = Self()
		try decoder.readBytes(into: &v)
		self.init(v)
	}
}

extension Float: FastCodable {
	public func fastEncode(to encoder: FastEncoder) {
		encoder.appendBytes(of: self)
	}

	public init(fromFast decoder: FastDecoder) throws {
		var v = Self()
		try decoder.readBytes(into: &v)
		self.init(v)
	}
}
