//
//  File.swift
//  
//
//  Created by Olli Tapaninen on 6.5.2021.
//

import Combine
import Foundation

struct WeatherClient {
    var observationForStation: (String) -> AnyPublisher<WeatherForStation, Error>
}

extension WeatherClient {
    static let mock = WeatherClient(
        observationForStation: { _ in
            Just(WeatherForStation(station: "Oulu", weatherDescription: "Cloudy", temperatureDegC: 12))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    )

    static let live = WeatherClient(
        observationForStation: { stationCode in

            let stationUrl = URL(string: "https://api.weather.gov/stations/")!.appendingPathComponent(stationCode)
            let weatherUrl = stationUrl.appendingPathComponent("observations/latest")

            let stationTask = urlSession
                .dataTaskPublisher(for: stationUrl)
                .map(\.data)
                .decode(type: WeatherResponse<WeatherStation>.self, decoder: decoder)

            let weatherTask = urlSession
                .dataTaskPublisher(for: weatherUrl)
                .map(\.data)
                .decode(type: WeatherResponse<WeatherObservation>.self, decoder: decoder)

            return stationTask.combineLatest(weatherTask)
                .map { (station, weather) in
                    WeatherForStation(
                        station: station.properties.name,
                        weatherDescription: weather.properties.textDescription,
                        temperatureDegC: weather.properties.temperature.value
                    )
                }
                .eraseToAnyPublisher()
        })
}
private let decoder = JSONDecoder()
private let urlSession = URLSession(configuration: .ephemeral)
