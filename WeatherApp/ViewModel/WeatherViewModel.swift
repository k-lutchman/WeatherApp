import Foundation

class WeatherViewModel {
    private let service = WeatherService()
    var weatherData: [Weather] = []
    private var cities: [(String, Double, Double)] = []
    private let country: String

    // Updated initializer to handle additional countries.
    init(country: String) {
        self.country = country
        if country == "UK" {
            cities = [
                ("London", 51.5074, -0.1278),
                ("Birmingham", 52.4862, -1.8936),
                ("Manchester", 53.4808, -2.2426),
                ("Edinburgh", 55.9533, -3.1883)
            ]
        } else if country == "France" {
            cities = [
                ("Paris", 48.8566, 2.3522),
                ("Lyon", 45.7640, 4.8357),
                ("Marseille", 43.2965, 5.3698),
                ("Nice", 43.7102, 7.2620)
            ]
        } else if country == "Spain" {
            cities = [
                ("Barcelona", 41.3851, 2.1734),
                ("Madrid", 40.4168, -3.7038),
                ("Seville", 37.3891, -5.9845),
                ("Valencia", 39.4699, -0.3763)
            ]
        } else if country == "Ireland" {
            cities = [
                ("Dublin", 53.3498, -6.2603),
                ("Cork", 51.8985, -8.4756),
                ("Limerick", 52.6638, -8.6267),
                ("Galway", 53.2707, -9.0568)
            ]
        }
    }
    
    func fetchWeather(completion: @escaping () -> Void) {
        let sortedCities = cities.sorted { $0.0 < $1.0 }
        let group = DispatchGroup()
        
        print("Fetching weather for cities in \(country) in alphabetical order...")
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
