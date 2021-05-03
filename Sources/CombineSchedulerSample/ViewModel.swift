//
//  ViewModel.swift
//  
//
//  Created by Olli Tapaninen on 3.5.2021.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {

    @Published var item: Int?

    let env: ModelEnvironment

    init(env: ModelEnvironment) {
        self.env = env
    }
}
