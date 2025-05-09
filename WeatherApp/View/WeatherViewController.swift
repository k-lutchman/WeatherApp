import UIKit

class WeatherViewController: UIViewController {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let selectedCountry: String
    private let countryEmoji: String
    private let viewModel: WeatherViewModel

    init(country: (name: String, emoji: String)) {
        self.selectedCountry = country.name
        self.countryEmoji = country.emoji
        self.viewModel = WeatherViewModel(country: country.name)
        super.init(nibName: nil, bundle: nil)
        self.title = "⛅️ Weather in \(country.emoji) \(country.name)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .paleBlue
        setupUI()
        loadWeather()
    }
    
    private func setupUI() {
        titleLabel.text = "Weather in \(selectedCountry)"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadWeather() {
        activityIndicator.startAnimating()
        viewModel.fetchWeather { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                print("Updating UI with \(self.viewModel.weatherData.count) cities")
                self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                for weather in self.viewModel.weatherData {
                    let tile = self.createWeatherTile(for: weather)
                    self.stackView.addArrangedSubview(tile)
                }
            }
        }
    }
    
    
    private func createWeatherTile(for weather: Weather) -> UIView {
        let cardView = WeatherCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 16)]
        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(NSAttributedString(string: "City: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(weather.city)\n", attributes: regularAttributes))
        attributedText.append(NSAttributedString(string: "Temperature: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(weather.temperature)°C\n", attributes: regularAttributes))
        attributedText.append(NSAttributedString(string: "Wind: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(weather.windSpeed)m/s\n", attributes: regularAttributes))
        attributedText.append(NSAttributedString(string: "Humidity: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(weather.humidity)%\n", attributes: regularAttributes))
        attributedText.append(NSAttributedString(string: "Precipitation: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(weather.precipitation) mm", attributes: regularAttributes))
        
        label.attributedText = attributedText
        
        let imageView = UIImageView(image: UIImage(systemName: "cloud.sun.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(label)
        cardView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -10),
            
            imageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10)
        ])
        
        return cardView
    }
}
