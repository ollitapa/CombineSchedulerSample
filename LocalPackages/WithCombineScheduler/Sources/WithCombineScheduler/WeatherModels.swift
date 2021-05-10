//
//  File.swift
//  
//
//  Created by Olli Tapaninen on 6.5.2021.
//

import Foundation

struct WeatherForStation: Equatable {
    var station: String
    var weatherDescription: String
    var temperatureDegC: Double
}

struct WeatherResponse<T: Codable>: Codable {
    var properties: T
}

struct WeatherStation: Codable {
    var name: String
}

struct WeatherObservation: Codable {
    struct Temperature: Codable {
        var value: Double
        var unitCode: String
    }
    var textDescription: String
    var temperature: Temperature
}
