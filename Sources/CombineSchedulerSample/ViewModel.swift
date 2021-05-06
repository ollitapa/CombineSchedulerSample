//
//  ViewModel.swift
//  
//
//  Created by Olli Tapaninen on 3.5.2021.
//

import Foundation
import Combine

enum WeatherState: Equatable {
    case empty
    case loading
    case failed(reason: String)
    case ok(WeatherForStation)
}

final class ViewModel: ObservableObject {

    @Published var item: WeatherState = .empty

    let env: ModelEnvironment

    private var cancellable = AnyCancellable {}

    init(env: ModelEnvironment) {
        self.env = env
    }

    func loadWeather() {
        item = .loading
        cancellable = env.weatherClient
            .observationForStation("KCLT")
            .subscribe(on: env.workScheduler) // Do fetch in background
            .receive(on: env.uiScheduler) // Handle events in Main thread
            .sink { [weak self] comletion in
                switch comletion {
                case .finished:
                    break
                case .failure(let fail):
                    self?.item = .failed(reason: fail.localizedDescription)
                }
            } receiveValue: { [weak self] weather in
                self?.item = .ok(weather)
            }
    }
}
