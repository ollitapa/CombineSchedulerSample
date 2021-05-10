import Foundation
import Combine


protocol MainViewModelType: ObservableObject {
    var state: MainViewState { get }
    func loadWeather()
}

enum MainViewState: Equatable {
    case empty
    case loading
    case failed(reason: String)
    case ok(WeatherForStation)
}


class MainViewModel: MainViewModelType {

    @Published var state: MainViewState = .empty
    private let weatherService: WeatherServing
    private var cancellable = AnyCancellable {}

    init(weatherService: WeatherServing) {
        self.weatherService = weatherService
    }

    func loadWeather() {
        state = .loading
        
        cancellable = weatherService.weatherForStation("KCLT")
            .sink { [weak self] comletion in
            guard case let .failure(error) = comletion else { return }
            self?.state = .failed(reason: error.localizedDescription)
            
        } receiveValue: { [weak self] weather in
            self?.state = .ok(weather)
        }
    }
}


class FakeMainViewModel: MainViewModelType {

    @Published var state: MainViewState = .empty
    func loadWeather() {}
    
    init(state: MainViewState) {
        self.state = state
    }
}
