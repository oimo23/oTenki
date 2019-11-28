//
//  ViewController.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/09/22.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Alamofire
import CoreLocation
import SwiftyJSON
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var cityName: UILabel!
    @IBOutlet private weak var temperature: UILabel!

    // MARK: - インスタンス化
    var weatherDataModel = WeatherDataModel() // 天気のDataModel
    let locationManager = CLLocationManager() // 位置情報を扱う
    let apiClient = APIClient() // APIリクエスト用

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

    // MARK: - 天気情報の更新
    /***************************************************************/
    func updateWeatherData(json: JSON) {

        // 天気DataModelを更新する
        weatherDataModel.updateWeatherData(json: json)

        // 更新されたデータで画面を描画する
        updateWeatherUI()

    }

    // MARK: - UI描画
    /***************************************************************/
    func updateWeatherUI() {

        cityName.text = weatherDataModel.city
        temperature.text = "\(weatherDataModel.temperature)C°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)

    }

    // MARK: - ロケーションから緯度経度を取得し、getWetherDataを発動する関数
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations[locations.count - 1]

        // 精度が1以上なら緯度経度を確定する
        if location.horizontalAccuracy > 0 {

            // 位置情報の更新をやめる
            self.locationManager.stopUpdatingLocation()

            // 確定した緯度経度のパラメータを引数に、APIを叩くための関数を発動する
            // getWeatherDataFromAPI(url: WEATHER_URL, parameters: params)
            self.apiClient.getWeatherData(locationCoordinate: location.coordinate) { [weak self] result in
                switch result {
                case .success(let weatherData):
                    self?.weatherDataModel = weatherData

                    DispatchQueue.main.async {
                        self?.updateWeatherUI()
                    }
                case .failure(let error):
                    // UIAlertControllerなどでerrorを表示
                    break
                }
            }

        }
    }

}
