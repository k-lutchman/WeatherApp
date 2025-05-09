import Foundation

class WeatherViewModel {
    private let service = WeatherService()
    var weatherData: [Weather] = []
    private var cities: [(String, Double, Double)] = []
    private let country: String
    
    private let citiesDictionary: [String: [(name: String, latitude: Double, longitude: Double)]] = [
        // European Countries
        "UK": [
            ("London", 51.5074, -0.1278),
            ("Birmingham", 52.4862, -1.8936),
            ("Manchester", 53.4808, -2.2426),
            ("Edinburgh", 55.9533, -3.1883),
            ("Liverpool", 53.4084, -2.9916),
            ("Bristol", 51.4545, -2.5879),
            ("Leeds", 53.8008, -1.5491),
            ("Glasgow", 55.8642, -4.2518),
            ("Newcastle", 54.9783, -1.6178),
            ("Sheffield", 53.3811, -1.4701),
            ("Nottingham", 52.9548, -1.1581),
            ("Southampton", 50.9097, -1.4044)
        ],
        "France": [
            ("Paris", 48.8566, 2.3522),
            ("Lyon", 45.7640, 4.8357),
            ("Marseille", 43.2965, 5.3698),
            ("Nice", 43.7102, 7.2620),
            ("Toulouse", 43.6045, 1.4442),
            ("Bordeaux", 44.8378, -0.5792),
            ("Strasbourg", 48.5734, 7.7521),
            ("Nantes", 47.2184, -1.5536),
            ("Lille", 50.6292, 3.0573),
            ("Rennes", 48.1173, -1.6778),
            ("Montpellier", 43.6108, 3.8767),
            ("Grenoble", 45.1885, 5.7245)
        ],
        "Spain": [
            ("Barcelona", 41.3851, 2.1734),
            ("Madrid", 40.4168, -3.7038),
            ("Seville", 37.3891, -5.9845),
            ("Valencia", 39.4699, -0.3763),
            ("Bilbao", 43.2630, -2.9350),
            ("Granada", 37.1773, -3.5986),
            ("Malaga", 36.7213, -4.4214),
            ("Zaragoza", 41.6488, -0.8891),
            ("Murcia", 37.9922, -1.1307),
            ("Palma", 39.5696, 2.6502),
            ("Alicante", 38.3452, -0.4810),
            ("Vigo", 42.2406, -8.7207)
        ],
        "Ireland": [
            ("Dublin", 53.3498, -6.2603),
            ("Cork", 51.8985, -8.4756),
            ("Limerick", 52.6638, -8.6267),
            ("Galway", 53.2707, -9.0568),
            ("Waterford", 52.2593, -7.1101),
            ("Dundalk", 54.0000, -6.4167),
            ("Sligo", 54.2769, -8.4761),
            ("Kilkenny", 52.6541, -7.2448),
            ("Drogheda", 53.7214, -6.3569),
            ("Swords", 53.4598, -6.2119),
            ("Navan", 53.6547, -6.6568),
            ("Ennis", 52.8431, -8.9861)
        ],
        // North American Countries
        "USA": [
            ("New York", 40.7128, -74.0060),
            ("Los Angeles", 34.0522, -118.2437),
            ("Chicago", 41.8781, -87.6298),
            ("San Francisco", 37.7749, -122.4194),
            ("Houston", 29.7604, -95.3698),
            ("Phoenix", 33.4484, -112.0740),
            ("Philadelphia", 39.9526, -75.1652),
            ("Miami", 25.7617, -80.1918),
            ("Dallas", 32.7767, -96.7970),
            ("Atlanta", 33.7490, -84.3880),
            ("San Diego", 32.7157, -117.1611),
            ("Denver", 39.7392, -104.9903)
        ],
        "Canada": [
            ("Toronto", 43.6532, -79.3832),
            ("Vancouver", 49.2827, -123.1207),
            ("Montreal", 45.5017, -73.5673),
            ("Calgary", 51.0447, -114.0719),
            ("Ottawa", 45.4215, -75.6972),
            ("Edmonton", 53.5461, -113.4938),
            ("Winnipeg", 49.8951, -97.1384),
            ("Quebec City", 46.8139, -71.2080),
            ("Hamilton", 43.2557, -79.8711),
            ("Kitchener", 43.4516, -80.4925),
            ("Halifax", 44.6488, -63.5752),
            ("Victoria", 48.4284, -123.3656)
        ],
        "Mexico": [
            ("Mexico City", 19.4326, -99.1332),
            ("Guadalajara", 20.6597, -103.3496),
            ("Monterrey", 25.6866, -100.3161),
            ("Cancun", 21.1619, -86.8515),
            ("Puebla", 19.0414, -98.2063),
            ("Tijuana", 32.5149, -117.0382),
            ("Leon", 21.1220, -101.6848),
            ("Merida", 20.9674, -89.5926),
            ("Chihuahua", 28.6353, -106.0889),
            ("San Luis Potosi", 22.1565, -100.9855),
            ("Queretaro", 20.5888, -100.3899),
            ("Acapulco", 16.8531, -99.8237)
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
