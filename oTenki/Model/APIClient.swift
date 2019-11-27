//
//  APIClient.swift
//  oTenki
//
//  Created by 伏貫祐樹 on 2019/10/03.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

final class APIClient {

    private(set) var payload: JSON?
    private(set) var gotError: Bool = false

    func request(method: HTTPMethod, url: String, parameters: [String: String]) {

        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in

            // 通信に成功
            if response.result.isSuccess {

                guard let result = response.result.value else { return }

                self.payload = JSON(result)
                self.gotError = false

                // 失敗
            } else {

                self.gotError = true

            }

        }

    }

}
