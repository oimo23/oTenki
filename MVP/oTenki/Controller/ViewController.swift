//
//  ViewController.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/09/22.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import UIKit
import CoreLocation

protocol ViewManager: class {
    func updateView()
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    // MARK: - インスタンス化
    /***************************************************************/
    let constants = Constants() // APIのURL、 APIKEYなどの定数、 gitでは管理しないので各自用意
    let weatherDataModel = WeatherDataModel() // 天気のDataModel
    let locationManager = CLLocationManager() // 位置情報を扱う
    
    private lazy var weatherPresenter = WeatherPresenter(view: self, weather: weatherDataModel, locationManager: locationManager)
    
    // MARK: - Viewがロードされた
    /***************************************************************/
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        weatherPresenter.viewDidLoad()
        
    }
    
    //MARK: - ロケーションから緯度経度を取得する
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let WEATHER_URL = constants.WEATHER_URL
        let APP_ID = constants.APP_ID
        let location = locations[locations.count - 1]
        
        weatherPresenter.locationUpdated(WEATHER_URL: WEATHER_URL, APP_ID: APP_ID, location: location)
        
    }

}

extension ViewController: ViewManager {
    
    // Viewを更新する
    func updateView() {

        cityName.text = weatherDataModel.city
        temperature.text = "\(weatherDataModel.temperature)C°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)

    }
    
}
