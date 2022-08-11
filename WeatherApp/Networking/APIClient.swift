//
//  APIClient.swift
//  WeatherApp
//
//  Created by Estefania Sassone on 04/08/2022.
//

import Foundation
import Alamofire
import PromiseKit

class APIClient: UICollectionViewController{
    
    static func descriptionDayPromises(_ city: String) -> Promise<String> {
        return Promise { resolver in
            AF.request("http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=e279928da4d766a7855a9e79b170d6ed&units=metric")
                .responseDecodable(of: APIData.self) {
                    response in
                    if let value = response.value {
                        let weather = value.weather
                        var descriptionDay: String = ""
                        for item in weather {
                            descriptionDay = item.weatherDescription
                        }
                        resolver.fulfill(descriptionDay)
                    } else {
                        resolver.reject(APIError.serverError)
                    }
                }
        }
    }
    
    static func weatherPromises(_ city: String) -> Promise<Clima> {
        return Promise { resolver in
            AF.request("http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=e279928da4d766a7855a9e79b170d6ed&units=metric")
                .responseDecodable(of: APIData.self) {
                    response in
                    if let value = response.value {
                        let temp = value.main.temp
                        let max = value.main.tempMax
                        let min = value.main.tempMin
                        let weather = Clima(temp: temp, tempMax: max, tempMin: min)
                        resolver.fulfill(weather)
                    } else {
                        resolver.reject(APIError.serverError)
                    }
                }
        }
    }
}
