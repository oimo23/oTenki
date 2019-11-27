//
//  Constants.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/09/22.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Foundation

// 定数クラスのサンプル
struct ConstantsSample {
    static let shared = ConstantsSample()

    let WEATHER_URL: String
    let APP_ID: String

    private init() {

        self.WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
        self.APP_ID = "YOUR_APP_ID"

    }
}
