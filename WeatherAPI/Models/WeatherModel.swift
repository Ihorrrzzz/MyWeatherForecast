//
//  Weather.swift
//  WeatherAPI
//
//  Created by IhorP on 13.05.2022.
//

import Foundation

public struct WeatherModel {
    let city: City?
    let temperature: Double
    let feelsLike: Double
    let humidity: String
    let windSpeed: Double
    let descriprion: String?
    let daily: [APIResponse.Daily]
    init(response: APIResponse, city: City?) {
        self.city = city
        temperature = response.current.temp
        feelsLike = response.current.feelsLike
        humidity = String(response.current.humidity)
        windSpeed = response.current.windSpeed
        descriprion = response.current.weather.description
        daily = response.daily
    }
}
