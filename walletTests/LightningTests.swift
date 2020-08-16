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
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLND() {
        Lightning.shared.purge()
        
        let startExpectation = expectation(description: "LND started")
        let rpcExpectation = expectation(description: "LND RPC became ready")
        
        Lightning.shared.start({ (error) in
            XCTAssertNil(error, "Start LND error")
            startExpectation.fulfill()
        }) { (error) in
            XCTAssertNil(error, "Start RPC error")
            rpcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
