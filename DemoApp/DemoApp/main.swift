//
//  main.swift
//  Demo
//
//  Created by Bryce Cogswell on 4/2/23.
//

import Foundation
import FastCodable

func testValue<T>(_ input: T) where T: FastCodable & Equatable {
	do {
		let buffer = FastEncoder.encode(input)
		let output = try FastDecoder.decode(T.self, from: buffer)
		guard
			output == input
		else {
			print("Error")
			return
		}
		print("Success!")
	} catch {
		print("Exception \(error)")
	}
}

let nilStringTest: String? = nil
testValue(nilStringTest)

struct Test2: FastCodable, Equatable {
	var a: Int8
	var b: String?
	var c: Int8

	init(a: Int8, b: String?, c: Int8) {
		self.a = a
		self.b = b
		self.c = c
	}

	init(fromFast decoder: FastDecoder) throws {
		a = try decoder.decode()
		b = try decoder.decode()
		c = try decoder.decode()
	}

	func fastEncode(to encoder: FastEncoder) {
		a.fastEncode(to: encoder)
		b.fastEncode(to: encoder)
		c.fastEncode(to: encoder)
	}
}

let structTest = Test2(a: 55, b: nil, c: 77)
testValue(structTest)

struct Test: FastCodable, Equatable {
	var a: Int
	var b: Double
	var c: UInt16
	var d: String?
	var e: [Int]

	init(a: Int, b: Double, c: UInt16, d: String?, e: [Int]) {
		self.a = a
		self.b = b
		self.c = c
		self.d = d
		self.e = e
	}

	init(fromFast decoder: FastDecoder) throws {
		a = try decoder.decode()
		b = try decoder.decode()
		c = try decoder.decode()
		d = try decoder.decode()
		e = try decoder.decode()
	}

	func fastEncode(to encoder: FastEncoder) {
		encoder.encode(a)
		encoder.encode(b)
		encoder.encode(c)
		encoder.encode(d)
		encoder.encode(e)
	}
}
let dictTest = [
	1: Test(a: 99, b: 3.14159, c: 0xFF21, d: "Hello", e: [1,2,3]),
	2: Test(a: 55, b: -1.0, c: 3, d: "World", e: [3,2,1,0]),
	3: Test(a: 1, b: 3.14159, c: 0xFF21, d: nil, e: [1,2,3])
]
testValue(dictTest)
