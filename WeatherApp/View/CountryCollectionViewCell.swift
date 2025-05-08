import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CountryCell"
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBlue 
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(countryLabel)
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with country: (name: String, emoji: String)) {
        countryLabel.text = "\(country.emoji) \(country.name)"
    }
}
