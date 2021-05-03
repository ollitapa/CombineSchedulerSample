//
//  MainView.swift
//  
//
//  Created by Olli Tapaninen on 3.5.2021.
//

import SwiftUI

struct MainView: View {

    @ObservedObject var model: ViewModel

    var body: some View {
        Text("Hello, World!")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(model: ViewModel(env: .mock))
    }
}
