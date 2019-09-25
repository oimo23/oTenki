//
//  ViewController.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/09/22.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    // MARK: - インスタンス化
    let constants = Constants() // APIのURL、APIKEYなどの定数、 gitでは管理しないので各自用意
    let weatherDataModel = WeatherDataModel() // 天気のDataModel
    let locationManager = CLLocationManager() // 位置情報を扱う
    
    // MARK: - Viewがロードされた
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // locationManager設定、100キロ精度を使用
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // 使用許可の認証をポップアップする
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - APIとの通信
    /***************************************************************/
    func getWeatherDataFromAPI(url: String, parameters: [String: String]) {
        
        // 引数のurlに対して、parametersを持たせてgetリクエストをする
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            // 通信に成功したなら天気情報の更新へ
            if response.result.isSuccess {
                
                // SwftyJSONによって、JSON型を指定出来るようになっている
                let weatherJSON: JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
            
            // 失敗ならエラーを知らせる
            } else {
                self.cityName.text = "通信に失敗しました"
            }
        }
    }
    
    //MARK: - 天気情報の更新
    /***************************************************************/
    func updateWeatherData(json: JSON) {
        
        // 天気DataModelを更新する
        weatherDataModel.updateWeatherData(json: json)
        
        // 更新されたデータで画面を描画する
        updateWeatherUI()
        
    }
    
    //MARK: - UI描画
    /***************************************************************/
    func updateWeatherUI() {
        cityName.text = weatherDataModel.city
        temperature.text = "\(weatherDataModel.temperature)C°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: - ロケーションから緯度経度を取得し、getWetherDataを発動する関数
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let WEATHER_URL = constants.WEATHER_URL
        let APP_ID = constants.APP_ID
        
        let location = locations[locations.count - 1]
        
        // 精度が1以上なら緯度経度を確定する
        if location.horizontalAccuracy > 0 {
            // 位置情報の更新をやめる
            self.locationManager.stopUpdatingLocation()
            
            let latitude  = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            // 確定した緯度経度のパラメータを引数に、APIを叩くための関数を発動する
            getWeatherDataFromAPI(url: WEATHER_URL, parameters: params)
        
        }
    }

}

