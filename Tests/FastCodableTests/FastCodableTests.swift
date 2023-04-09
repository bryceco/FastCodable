import XCTest
@testable import FastCodable

final class FastCodableTests: XCTestCase {
    func testExample() throws {
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
				a = try Int(fromFast: decoder)
				b = try Double(fromFast: decoder)
				c = try UInt16(fromFast: decoder)
				d = try String(fromFast: decoder)
				e = try [Int](fromFast: decoder)
			}

			func fastEncode(to encoder: FastEncoder) {
				a.fastEncode(to: encoder)
				b.fastEncode(to: encoder)
				c.fastEncode(to: encoder)
				d.fastEncode(to: encoder)
				e.fastEncode(to: encoder)
			}
		}

		let dict = [
			1: Test(a: 99, b: 3.14159, c: 0xFF21, d: "Hello", e: [1,2,3]),
			2: Test(a: 55, b: -1.0, c: 3, d: "World", e: [3,2,1,0]),
			3: Test(a: 1, b: 3.14159, c: 0xFF21, d: nil, e: [1,2,3])
		]
		let data = FastEncoder.encode(dict)
		let dict2 = try FastDecoder.decode(type(of: dict).self, data: data)
        XCTAssertEqual(dict, dict2)
    }
}
