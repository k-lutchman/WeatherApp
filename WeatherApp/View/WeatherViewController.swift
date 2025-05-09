import UIKit

final class WeatherViewController: UIViewController {
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
        stackView.spacing = UIConstants.stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topPadding),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.stackSpacing),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.stackHorizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.stackHorizontalPadding),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadWeather() {
        activityIndicator.startAnimating()
        viewModel.fetchWeather {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
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
        cardView.alpha = 0.0
        cardView.heightAnchor.constraint(equalToConstant: UIConstants.weatherTileHeight).isActive = true
        
        
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
            label.topAnchor.constraint(equalTo: cardView.topAnchor, constant: UIConstants.cardPadding),
            label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: UIConstants.cardPadding),
            label.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -UIConstants.cardPadding),
            
            imageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -UIConstants.cardPadding)
        ])
        
        
        cardView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        // Animate fade-in 0.8 seconds.
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
            cardView.alpha = 1.0
            cardView.transform = .identity
        }, completion: nil)
        
        return cardView
    }
}
