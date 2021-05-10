import SwiftUI

public let mainView = AnyView(MainView(model: MainViewModel(weatherService: WeatherService())))

struct MainView<Model: MainViewModelType>: View {

    @ObservedObject var model: Model
    
    var body: some View {
        NavigationView {
            Group {
                switch model.state {
                case .empty:
                    Text("Nothing").font(.title)

                case .ok(let weather):
                    VStack(alignment: .leading) {
                        Text("Station:").foregroundColor(.gray)
                        Text(weather.station).font(.title)
                        Text("Conditions:").foregroundColor(.gray)
                        Text(weather.weatherDescription).font(.title)
                        Text("Temperature:").foregroundColor(.gray)
                        Text("\(Int(weather.temperatureDegC)) °C").font(.title)
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
        MainView(model: FakeMainViewModel(state: .empty))
        MainView(model: FakeMainViewModel(state: .failed(reason: "Error description placeholder")))
        MainView(model: FakeMainViewModel(state: .loading))
        MainView(model: FakeMainViewModel(state: .ok(WeatherForStation(station: "station", weatherDescription: "weatherDescription", temperatureDegC: 0))))
        
        MainView(model: MainViewModel(weatherService: WeatherService()))
    }
}
