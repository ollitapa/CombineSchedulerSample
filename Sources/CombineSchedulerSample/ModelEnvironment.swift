//
//  ModelEnvironment.swift
//  
//
//  Created by Olli Tapaninen on 3.5.2021.
//

import Foundation
import Combine
import CombineSchedulers

struct ModelEnvironment {

    var workScheduler: AnySchedulerOf<DispatchQueue>
    var uiScheduler: AnySchedulerOf<UIScheduler>
    var weatherClient: WeatherClient
}

extension ModelEnvironment {
    static let mock = ModelEnvironment(
        workScheduler: DispatchQueue.immediate.eraseToAnyScheduler(),
        uiScheduler: UIScheduler.shared.eraseToAnyScheduler(),
        weatherClient: .mock
    )

    static let live = ModelEnvironment(
        workScheduler: DispatchQueue(label: "com.scheduler.test").eraseToAnyScheduler(),
        uiScheduler: UIScheduler.shared.eraseToAnyScheduler(),
        weatherClient: .live
    )
}
