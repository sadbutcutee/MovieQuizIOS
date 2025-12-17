//
//  ArrayTests.swift
//  MovieQuiz
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1, 1, 2, 3, 5]
        let value = array[safe: 2]
        
        XCTAssertEqual(value, 2)
        XCTAssertNotNil(value)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1, 1, 2, 3, 5]
        let value = array[safe: 20]
        
        XCTAssertNil(value)
    }
}
