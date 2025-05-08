import UIKit

class WeatherViewController: UIViewController {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let viewModel = WeatherViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large) // 🔄 Loading Spinner
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWeather()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        titleLabel.text = "Weather"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Activity Indicator Setup 🔄
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadWeather() {
        activityIndicator.startAnimating() // Show spinner before fetching data 🔄
        
        viewModel.fetchWeather {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating() // Hide spinner when done 🔄
                
                print("Updating UI with \(self.viewModel.weatherData.count) cities")
                
                for weather in self.viewModel.weatherData {
                    let tile = self.createWeatherTile(for: weather)
                    self.stackView.addArrangedSubview(tile)
                }
            }
        }
    }
    
    private func createWeatherTile(for weather: Weather) -> UIView {
        let tile = UIView()
        tile.backgroundColor = .systemBlue
        tile.layer.cornerRadius = 10
        tile.translatesAutoresizingMaskIntoConstraints = false
        tile.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let label = UILabel()
        label.text = "\(weather.city): \(weather.temperature)°C\nWind: \(weather.windSpeed)m/s\nHumidity: \(weather.humidity)%\nPrecipitation: \(weather.precipitation) mm"
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "cloud.sun.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        tile.addSubview(label)
        tile.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: tile.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: tile.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -10),
            
            imageView.centerYAnchor.constraint(equalTo: tile.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: tile.trailingAnchor, constant: -10)
        ])
        
        return tile
    }
}
