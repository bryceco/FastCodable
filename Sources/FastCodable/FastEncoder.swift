//
//  FastEncoder.swift
//
//  Created by Bryce Cogswell on 4/1/23.
//  Copyright © 2023 Bryce Cogswell. All rights reserved.
//

import Foundation

public protocol FastEncodable {
	func fastEncode(to encoder: FastEncoder)
}

public final class FastEncoder {
	private var data: Data

	static let Terminator: UInt64 = 0xDEADBEEF0000AA99

	init() {
		data = Data()
	}

	public static func encode<T: FastEncodable>(_ value: T) -> Data {
		let encoder = FastEncoder()
		value.fastEncode(to: encoder)
		Self.Terminator.fastEncode(to: encoder)
		return encoder.data
	}

	public func encode<T: FastEncodable>(_ value: T) {
		value.fastEncode(to: self)
	}

	@inline(__always)
	func appendBytes<T>(of: T) {
		var target = of
		withUnsafeBytes(of: &target) {
			data.append(contentsOf: $0)
		}
	}
}
