//
//  walletTests.swift
//  walletTests
//
//  Created by Michael Miller on 8/12/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import XCTest
@testable import wallet

class walletTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Lightning.shared.purge()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLND() {
        Lightning.shared.start { (error) in
            XCTAssertNil(error)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
