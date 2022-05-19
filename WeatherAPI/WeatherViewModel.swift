//
//  WeatherViewModel.swift
//  WeatherAPI
//
//  Created by IhorP on 15.05.2022.
//

import Foundation


class WeatherViewModel {
    var cityName: String = "City Name"
    var temperature: Double = 0
    var windSpeed: Double = 0
    var feel: Double = 0
    var humidity: String = "--"
    var dayOfWeek: String = "--"

    lazy var currentWeekDay:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    init(with model: WeatherModel) {
        let name = model.city?.localNames[Locale.current.languageCode ?? "en"] ?? model.city?.name
        cityName = name ?? "😢"
        temperature = model.temperature
        windSpeed = model.windSpeed
        feel = model.feelsLike
        humidity = model.humidity
        dayOfWeek = currentWeekDay.string(from: Date()).capitalized
    }
}
