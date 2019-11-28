//
//  WeatherPresenter.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/09/28.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Alamofire
import Foundation
import CoreLocation
import SwiftyJSON

final class WeatherPresenter {
    
    private weak var view: ViewController?
    private weak var weather: WeatherDataModel?
    private weak var locationManager:CLLocationManager?
    
    init(view: ViewController, weather: WeatherDataModel, locationManager: CLLocationManager) {
        
        self.view = view
        self.weather = weather
        self.locationManager = locationManager
        
    }
    
    func viewDidLoad() {
        
        // locationManager設定、100キロ精度を使用
        locationManager?.delegate = self.view
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // 使用許可の認証をポップアップする
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        // Viewを更新
        view?.updateView()
        
    }
    
    func locationUpdated(WEATHER_URL: String, APP_ID: String, location: CLLocation) {
        
        // 精度が1以上なら緯度経度を確定する
        if location.horizontalAccuracy > 0 {
            
            // 位置情報の更新をやめる
            self.locationManager?.stopUpdatingLocation()
            
            let latitude  = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            // 確定した緯度経度のパラメータを引数に、APIを叩くための関数を発動する
            getWeatherDataFromAPI(url: WEATHER_URL, parameters: params)
            
        }
        
    }
    
    //MARK: - APIとの通信
    /***************************************************************/
    private func getWeatherDataFromAPI(url: String, parameters: [String: String]) {
        
        // 引数のurlに対して、parametersを持たせてgetリクエストをする
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            // 通信に成功したなら天気情報の更新へ
            if response.result.isSuccess {
                
                // SwftyJSONによって、JSON型を指定出来るようになっている
                let weatherJSON: JSON = JSON(response.result.value!)
                
                self.weather?.updateWeatherData(json: weatherJSON)
                
                self.view?.updateView()
                
                // 失敗ならエラーを知らせる
            } else {
                
                self.view?.cityName.text = "通信に失敗しました"
                
            }
            
        }
    }
}
