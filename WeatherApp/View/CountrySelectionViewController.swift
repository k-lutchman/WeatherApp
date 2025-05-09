import UIKit

class CountrySelectionViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let continent: String
    private var countries: [(name: String, emoji: String)] = []
    
    init(continent: (name: String, emoji: String)) {
        self.continent = continent.name
        super.init(nibName: nil, bundle: nil)
        self.title = "⛅️ Countries in \(continent.name)"
        
        switch continent.name {
        case "Europe":
            countries = [
                ("UK", "🇬🇧"),
                ("France", "🇫🇷"),
                ("Spain", "🇪🇸"),
                ("Ireland", "🇮🇪")
            ]
        case "North America":
            countries = [
                ("USA", "🇺🇸"),
                ("Canada", "🇨🇦"),
                ("Mexico", "🇲🇽")
            ]
        default:
            countries = []
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleBlue
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIConstants.cellItemSize
        layout.minimumLineSpacing = UIConstants.cellLineSpacing
        layout.minimumInteritemSpacing = UIConstants.cellInteritemSpacing
        layout.sectionInset = UIConstants.cellSectionInset
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CountryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CountryCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CountrySelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CountryCollectionViewCell.reuseIdentifier, for: indexPath)
                as? CountryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: countries[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedCountry = countries[indexPath.item]
        let weatherVC = WeatherViewController(country: selectedCountry)
        navigationController?.pushViewController(weatherVC, animated: true)
    }
}
