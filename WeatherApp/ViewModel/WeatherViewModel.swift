import Foundation

class WeatherViewModel {
    private let service = WeatherService()
    var weatherData: [Weather] = []
    
    func fetchWeather(completion: @escaping () -> Void) {
        let cities = [
            ("London", 51.5074, -0.1278),
            ("Birmingham", 52.4862, -1.8936),
            ("Manchester", 53.4808, -2.2426),
            ("Edinburgh", 55.9533, -3.1883)
        ]
        
        let sortedCities = cities.sorted { $0.0 < $1.0 }
        
        let group = DispatchGroup()
        
        print("Fetching weather for cities in alphabetical order...")
        
        for (city, lat, lon) in sortedCities {
            group.enter()
            service.fetchWeather(for: city, latitude: lat, longitude: lon) { weather in
                if let weather = weather {
                    self.weatherData.append(weather)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("Weather fetched successfully, data count: \(self.weatherData.count)")
            completion()
        }
    }
}
