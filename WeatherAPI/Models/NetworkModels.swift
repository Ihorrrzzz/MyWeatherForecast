//
//  Models.swift
//  WeatherAPI
//
//  Created by IhorP on 12.05.2022.
//

import Foundation

struct APIResponse: Decodable {
    struct Current: Decodable {
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feelsLike: Double
        let humidity: Int
        let windSpeed: Double

        struct Weather: Decodable {
            let main: String
            let descriprion: String?
        }

        let weather: [Weather]
    }
    struct Daily: Decodable {

        struct Temperature: Decodable {
            let day: Double
            let min: Double?
            let max: Double?
            let night: Double
            let evening: Double
            let morning: Double

            enum CodingKeys: String, CodingKey {
                case day
                case min
                case max
                case night
                case evening = "eve"
                case morning = "morn"
            }
        }
        struct Weather: Decodable {
            let main: String
        }
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let humidity: Int
        let windSpeed: Double
        let feelsLike: Temperature
        let temp: Temperature
        let weather: [Weather]

        func getMessage() -> String {
            """
sunrise: \(getTime(time: sunrise))
sunset: \(getTime(time: sunset))
humidity: \(humidity)%
windSpeed: \(Int(windSpeed))
--------------
feelsLike:
day: \(feelsLike.day)
night: \(feelsLike.night)
evening: \(feelsLike.evening)
morning: \(feelsLike.morning)
--------------
temperature:
 day: \(temp.day)
 night: \(temp.night)
 evening: \(temp.evening)
 morning: \(temp.morning)
--------------
weather: \(weather.first?.main ?? "")
"""
        }

        func getTime(time:Int) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM, d HH:mm"
            let newDate = Date(timeIntervalSince1970: TimeInterval(time))
            return dateFormatter.string(from: newDate)

        }
    }

    let timezone: String 
    let lat: Double
    let lon: Double
    let current: Current
    let daily: [Daily]
}
