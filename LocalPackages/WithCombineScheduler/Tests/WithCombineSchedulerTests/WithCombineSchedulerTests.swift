import XCTest
@testable import WithCombineScheduler
import CombineSchedulers

final class WithCombineSchedulerTests: XCTestCase {
    
    func testLoadingIsShowWhenWeatherIsFetched() {
        
        let workSchd = DispatchQueue.test
        var env = ModelEnvironment.mock
        env.workScheduler = workSchd.eraseToAnyScheduler()
        
        let model = ViewModel(env: env)
        
        // Nothing done yet
        XCTAssertEqual(model.item, .empty)
        
        // Start loading the weather
        model.loadWeather()
        XCTAssertEqual(model.item, .loading)
        
        // Deliver weather result
        workSchd.advance()
        
        XCTAssertEqual(
            model.item,
            .ok(WeatherForStation(station: "Oulu", weatherDescription: "Cloudy", temperatureDegC: 12.0))
        )
    }
}

