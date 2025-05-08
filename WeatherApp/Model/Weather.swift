import Foundation

struct Weather: Codable {
    let city: String
    let temperature: Double
    let windSpeed: Double
    let humidity: Int
    let precipitation: Double
}

struct OpenMeteoResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature_2m: Double
    let wind_speed_10m: Double
    let relative_humidity_2m: Int
    let precipitation: Double
}
