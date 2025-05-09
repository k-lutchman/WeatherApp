import Foundation

final class WeatherService {
    func fetchWeather(for city: String, latitude: Double, longitude: Double, completion: @escaping (Weather?) -> Void) {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,wind_speed_10m,relative_humidity_2m,precipitation"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        print("Fetching data for: \(city), URL: \(urlString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let decodedResponse = try? JSONDecoder().decode(OpenMeteoResponse.self, from: data) {
                let currentWeather = decodedResponse.current
                let weather = Weather(
                    city: city,
                    temperature: currentWeather.temperature_2m,
                    windSpeed: currentWeather.wind_speed_10m,
                    humidity: currentWeather.relative_humidity_2m,
                    precipitation: currentWeather.precipitation
                )
                DispatchQueue.main.async {
                    completion(weather)
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
