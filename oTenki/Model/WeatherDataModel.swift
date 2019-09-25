//
//  WeatherDataModel.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/09/22.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Foundation
import SwiftyJSON

final class WeatherDataModel {

    private(set) var temperature: Int = 0
    private(set) var condition: Int = 0
    private(set) var city: String = ""
    private(set) var weatherIconName: String = ""
    
    // 天気情報を更新する
    func updateWeatherData(json: JSON) {
        
        // 温度（ただし華氏温度なので変換を挟む）
        let temperature = json["main"]["temp"].doubleValue
        self.temperature = Int(temperature - 273.15)
        
        // 都市名
        self.city = json["name"].stringValue
        
        // 天候名を表すための数値
        self.condition = json["weather"][0]["id"].intValue
        
        // 上記のconditionをもとにアイコンを決定する
        self.weatherIconName = self.updateWeatherIcon(condition: self.condition)
        
    }
    
    // アイコンを天気conditionの数値に応じて更新する
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
    
}
