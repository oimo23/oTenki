//
//  oTenkiTests.swift
//  oTenkiTests
//
//  Created by 伏貫祐樹 on 2019/09/22.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import oTenki

class oTenkiTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherDataModel() {

        let weatherDatamodel = WeatherDataModel()

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.url(forResource: "stub", withExtension: "json")
        let stubData: NSData? = try? NSData(contentsOf: path!, options: .uncached)

        weatherDatamodel.updateWeatherData(json: JSON(stubData!))

        XCTAssertEqual(weatherDatamodel.city, "Tawarano")
        XCTAssertEqual(weatherDatamodel.weatherIconName, "sunny")

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
