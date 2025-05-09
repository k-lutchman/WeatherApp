import Foundation

class WeatherViewModel {
    private let service = WeatherService()
    var weatherData: [Weather] = []
    private var cities: [(String, Double, Double)] = []
    private let country: String
    
    private let citiesDictionary: [String: [(String, Double, Double)]] = [
        // European Countries
        "UK": [
            ("London", 51.5074, -0.1278),
            ("Birmingham", 52.4862, -1.8936),
            ("Manchester", 53.4808, -2.2426),
            ("Edinburgh", 55.9533, -3.1883)
        ],
        "France": [
            ("Paris", 48.8566, 2.3522),
            ("Lyon", 45.7640, 4.8357),
            ("Marseille", 43.2965, 5.3698),
            ("Nice", 43.7102, 7.2620)
        ],
        "Spain": [
            ("Barcelona", 41.3851, 2.1734),
            ("Madrid", 40.4168, -3.7038),
            ("Seville", 37.3891, -5.9845),
            ("Valencia", 39.4699, -0.3763)
        ],
        "Ireland": [
            ("Dublin", 53.3498, -6.2603),
            ("Cork", 51.8985, -8.4756),
            ("Limerick", 52.6638, -8.6267),
            ("Galway", 53.2707, -9.0568)
        ],
        // North Aemerican Countries
        "USA": [
            ("New York", 40.7128, -74.0060),
            ("Los Angeles", 34.0522, -118.2437),
            ("Chicago", 41.8781, -87.6298),
            ("San Francisco", 37.7749, -122.4194)
        ],
        "Canada": [
            ("Toronto", 43.6532, -79.3832),
            ("Vancouver", 49.2827, -123.1207),
            ("Montreal", 45.5017, -73.5673),
            ("Calgary", 51.0447, -114.0719)
        ],
        "Mexico": [
            ("Mexico City", 19.4326, -99.1332),
            ("Guadalajara", 20.6597, -103.3496),
            ("Monterrey", 25.6866, -100.3161),
            ("Cancun", 21.1619, -86.8515)
        ]
    ]
    
    init(country: String) {
        self.country = country
        self.cities = citiesDictionary[country] ?? []
    }
    
    func fetchWeather(completion: @escaping () -> Void) {
        let sortedCities = cities.sorted { $0.0 < $1.0 }
        let group = DispatchGroup()
        
        print("Fetching weather for cities in \(country) in alphabetical order...")
        
        for (city, lat, lon) in sortedCities {
            group.enter()
            service.fetchWeather(for: city, latitude: lat, longitude: lon) { [weak self] weather in
                guard let self = self else {
                    group.leave()
                    return
                }
                
                DispatchQueue.main.async {
                    if let weather = weather {
                        self.weatherData.append(weather)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.weatherData.sort { $0.city < $1.city }
            print("Weather fetched successfully, data count: \(self.weatherData.count)")
            completion()
        }
    }
}
