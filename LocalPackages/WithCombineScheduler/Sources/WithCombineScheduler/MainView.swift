//
//  MainView.swift
//  
//
//  Created by Olli Tapaninen on 3.5.2021.
//

import SwiftUI

public let mainView = AnyView(MainView(model: ViewModel(env: .live)))

struct MainView: View {

    @ObservedObject var model: ViewModel

    var body: some View {
        NavigationView {
            Group {
                switch model.item {
                case .empty:
                    Text("Nothing").font(.title)

                case .ok(let weather):
                    VStack(alignment: .leading) {
                        Text("Station:").foregroundColor(.gray)
                        Text(weather.station).font(.title)
                        Text("Conditions:").foregroundColor(.gray)
                        Text(weather.weatherDescription).font(.title)
                        Text("Temperature:").foregroundColor(.gray)
                        Text("\(weather.temperatureDegC)").font(.title)
                    }
                    .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .topLeading)

                case .loading:
                    Text("Loading...").font(.title)
                    
                case .failed(let reason):
                    VStack {
                        Text("Failed").font(.title)
                        Text(reason)
                    }
                }
            }
            .padding()
            .navigationBarTitle("Weather")
        }
        .onAppear {
            model.loadWeather()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(model: ViewModel(env: .mock))
        MainView(model: ViewModel(env: .live))
    }
}
