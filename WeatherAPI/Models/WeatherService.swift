//
//  WeatherService.swift
//  WeatherAPI
//
//  Created by IhorP on 12.05.2022.
//

import Foundation

public final class WeatherService: NSObject {
    typealias WeatherComplition = ((WeatherModel) -> Void)
    private let API_KEY = "ec4d308bba31c84c25c43234eaf14370"
    private let baseURL = "https://api.openweathermap.org/"

    public override init() {
        super.init()
    }

    func decode<T: Decodable>(of: T.Type, data: Data?) -> T? {
        guard let data = data else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(T.self, from: data)
            return response
        } catch {
            print(error)
        }
        return nil

    }

    func makeWeatherRequest(city: City, completion: @escaping WeatherComplition) {
        self.makeWeatherRequest(with: city.lat, longitude: city.lon, completion: completion)
    }

    func makeWeatherRequest(with latitude: Double,
                            longitude: Double,
                            cityName: City? = nil,
                            completion: @escaping WeatherComplition) {
        let queryParameters = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "exclude", value: "hourly"),
            URLQueryItem(name: "appid", value: API_KEY),
            URLQueryItem(name: "units", value: "metric")
            ]
        guard var urlComponents = URLComponents(string: baseURL.appending("data/2.5/onecall")) else { return }

        urlComponents.queryItems = queryParameters
        guard let url = urlComponents.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let weatherResponse = self.decode(of: APIResponse.self, data: data) else { return }
            if let cityName = cityName {
                DispatchQueue.main.async {
                    completion(WeatherModel(response: weatherResponse,city: cityName))
                }
            } else {
                self.getCityName(lat: latitude, lon: longitude) { city in
                    DispatchQueue.main.async {
                        completion(WeatherModel(response: weatherResponse,city: city))
                    }
                }

            }
        }.resume()
    }

//http://api.openweathermap.org/geo/1.0/reverse?lat=49.841032&lon=24.030639&limit=5&appid=ec4d308bba31c84c25c43234eaf14370

    private func getCityName(lat: Double, lon: Double, completion: @escaping (City?) -> Void) {
        let queryParameters = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: API_KEY),
            URLQueryItem(name: "limin", value: String(10)),
            ]
        guard var urlComponents = URLComponents(string: baseURL.appending("geo/1.0/reverse")) else { return }

        urlComponents.queryItems = queryParameters
        guard let url = urlComponents.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            let object = self.decode(of: [City].self, data: data)
            completion(object?.first)
        }.resume()
    }

    private func getCoords(for cityName: String,
                           multipleCitiesHandler: @escaping ([City]) -> Void,
                           completion: @escaping WeatherComplition) {
        let queryParameters = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: API_KEY),
            URLQueryItem(name: "limin", value: String(100)),
            ]
        guard var urlComponents = URLComponents(string: baseURL.appending("geo/1.0/direct")) else { return }

        urlComponents.queryItems = queryParameters
        guard let url = urlComponents.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let object = self.decode(of: [City].self, data: data) else { return }
            if object.count >= 2 {
                DispatchQueue.main.async {
                    multipleCitiesHandler(object)
                }
                return
            } else if let city = object.first {
                self.makeWeatherRequest(with: city.lat, longitude: city.lon, cityName: city, completion: completion)
            }
        }.resume()

    }

    func getWeather(cityName: String,
                    multipleCitieshandler: @escaping ([City]) -> Void,
                    completion: @escaping WeatherComplition) {
        getCoords(for: cityName, multipleCitiesHandler: multipleCitieshandler, completion: completion)
    }
}

struct City: Decodable {
    let name: String
    let localNames: [String:String]
    let lat: Double
    let lon: Double
    let country: String
    let state: String

}
