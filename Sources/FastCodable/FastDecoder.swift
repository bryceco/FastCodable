//
//  FastDecoder.swift
//
//  Created by Bryce Cogswell on 4/1/23.
//  Copyright © 2023 Bryce Cogswell. All rights reserved.
//

import Foundation

public protocol FastDecodable {
	init(fromFast decoder: FastDecoder) throws
}

public final class FastDecoder {
	let data: Data
	var cursor: Int

	public enum Error: Swift.Error {
		case prematureEndOfData
		case invalidTerminatorMark
		case invalidUTF8([UInt8])
	}

	public init(data: Data) {
		self.data = data
		cursor = 0
	}

	public static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: FastDecodable {
		let decoder = FastDecoder(data: data)
		let value = try type.init(fromFast: decoder)
		guard
			try UInt64(fromFast: decoder) == FastEncoder.Terminator
		else {
			throw Error.invalidTerminatorMark
		}
		return value
	}

	public func decode<T>() throws -> T where T: FastDecodable {
		return try T(fromFast: self)
	}

	@inline(__always)
	func readBytes<T>(into: inout T) throws {
		try read(MemoryLayout<T>.size, into: &into)
	}

	@inline(__always)
	private func read(_ byteCount: Int, into: UnsafeMutableRawPointer) throws {
		if cursor + byteCount > data.count {
			throw FastDecoder.Error.prematureEndOfData
		}
		data.withUnsafeBytes({
			let from = $0.baseAddress! + cursor
			memcpy(into, from, byteCount)
		})
		cursor += byteCount
	}
}
