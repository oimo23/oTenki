//
//  APIClient.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/10/03.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation

enum APIClientError: Swift.Error {
    case responseError(Swift.Error)
    case requestError(Swift.Error)
    case unknownError
}

final class APIClient {

    func getWeatherData(
        locationCoordinate: CLLocationCoordinate2D,
        completion: @escaping (Swift.Result<WeatherDataModel, APIClientError>) -> Void
    ) {
        Alamofire.request(
            Constants.shared.WEATHER_URL,
            method: .get,
            parameters: [
                "lat": String(locationCoordinate.latitude),
                "lon": String(locationCoordinate.longitude),
                "appid": Constants.shared.APP_ID
            ]
        )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let weatherData = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                        completion(.success(weatherData))
                    } catch {
                        completion(.failure(.responseError(error)))
                    }
                case .failure(let error):
                    completion(.failure(.requestError(error)))
                }
            }
    }

}
