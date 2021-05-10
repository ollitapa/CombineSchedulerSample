import Combine
import Foundation

protocol WeatherServing: AnyObject {
    func weatherForStation(_ stationCode: String) -> AnyPublisher<WeatherForStation, Error>
}

class WeatherService: WeatherServing {
    private let urlSession = URLSession(configuration: .ephemeral)
    private let decoder = JSONDecoder()
    
    func weatherForStation(_ stationCode: String) -> AnyPublisher<WeatherForStation, Error> {

        let stationURL = URL(string: "https://api.weather.gov/stations/")!.appendingPathComponent(stationCode)
        let weatherURL = stationURL.appendingPathComponent("observations/latest")

        let stationTask = urlSession
            .dataTaskPublisher(for: stationURL)
            .map(\.data)
            .decode(type: WeatherResponse<WeatherStation>.self, decoder: decoder)

        let weatherTask = urlSession
            .dataTaskPublisher(for: weatherURL)
            .map(\.data)
            .decode(type: WeatherResponse<WeatherObservation>.self, decoder: decoder)

        return stationTask.combineLatest(weatherTask)
            .receive(on: DispatchQueue.main)
            .map { (station, weather) in
                WeatherForStation(
                    station: station.properties.name,
                    weatherDescription: weather.properties.textDescription,
                    temperatureDegC: weather.properties.temperature.value
                )
            }
            .eraseToAnyPublisher()
    }
}

class FakeWeatherService: WeatherServing {
    let weatherForStation_return = PassthroughSubject<WeatherForStation, Error>()
    func weatherForStation(_ stationCode: String) -> AnyPublisher<WeatherForStation, Error> {
        return weatherForStation_return.eraseToAnyPublisher()
    }
}
