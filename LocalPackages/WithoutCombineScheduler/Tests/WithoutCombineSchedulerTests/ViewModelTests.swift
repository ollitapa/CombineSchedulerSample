    import XCTest
    import Combine
    @testable import WithoutCombineScheduler

    final class ViewModelTests: XCTestCase {
        var weatherService: FakeWeatherService!
        var viewModel: MainViewModel!
        
        override func setUp() {
            weatherService = FakeWeatherService()
            viewModel = MainViewModel(weatherService: weatherService)
        }
        
        func testViewModelStates() {
            // Nothing done yet
            XCTAssertEqual(viewModel.state, .empty)
            
            
            // Start loading the weather
            viewModel.loadWeather()
            XCTAssertEqual(viewModel.state, .loading)
            
            // Deliver weather result
            let mockWeatherForStation = WeatherForStation(station: "station", weatherDescription: "weatherDescription", temperatureDegC: 0)
            weatherService.weatherForStation_return.send(mockWeatherForStation)
            
            XCTAssertEqual(viewModel.state, .ok(mockWeatherForStation))
        }
    }
