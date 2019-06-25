//
//  NewsFeedTests.swift
//  NewsFeedTests
//
//  Created by gauss on 6/21/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import XCTest
@testable import NewsFeed

class NewsFeedTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // Mark - one of the test case for the core data manager api
    func testFetchNewsItemList() {
        CoreDataManager.shared.fetchNewsItemList { (result, error) in
            print("testFetchNewsItemList error \(result)")
            XCTAssertNil(error, "fetch news error")
        }
    }
}
