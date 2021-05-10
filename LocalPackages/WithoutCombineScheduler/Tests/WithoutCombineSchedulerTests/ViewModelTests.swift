import XCTest
import Combine
@testable import WithoutCombineScheduler

final class ViewModelTests: XCTestCase {
    var weatherService: FakeWeatherService!
    var viewModel: MainViewModel!
    
    enum MockError: LocalizedError {
        case failed
        
        var errorDescription: String? {
            switch self {
            case .failed: return "Test Error - failed"
            }
        }
    }
    
    override func setUp() {
        weatherService = FakeWeatherService()
        viewModel = MainViewModel(weatherService: weatherService)
    }
    
    func testViewModelSuccessStates() {
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
    
    func testViewModelFailState() {
        // Start loading the weather
        viewModel.loadWeather()
        
        // Deliver failure result
        weatherService.weatherForStation_return.send(completion: Subscribers.Completion<Error>.failure(MockError.failed))
        XCTAssertEqual(viewModel.state, .failed(reason: MockError.failed.localizedDescription))
    }
}


