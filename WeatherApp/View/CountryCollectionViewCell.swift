import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CountryCell"
    
    
    private let cardView: WeatherCardView = {
        let card = WeatherCardView()
        card.layer.cornerRadius = 10
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        
        contentView.addSubview(cardView)
        cardView.addSubview(countryLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            countryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            countryLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            countryLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with country: (name: String, emoji: String)) {
        let attributedText = NSMutableAttributedString()
        
        let emojiAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black  
        ]
        
        attributedText.append(NSAttributedString(string: "\(country.emoji) ", attributes: emojiAttributes))
        attributedText.append(NSAttributedString(string: country.name, attributes: nameAttributes))
        
        countryLabel.attributedText = attributedText
    }
}
