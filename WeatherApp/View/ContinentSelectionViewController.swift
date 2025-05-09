import UIKit

class ContinentSelectionViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    private let continents: [(name: String, emoji: String)] = [
        ("Europe", "🇪🇺"),
        ("North America", "🌎")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleBlue
        self.title = "⛅️ Continents"
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

extension ContinentSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return continents.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CountryCollectionViewCell.reuseIdentifier, for: indexPath)
                as? CountryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: continents[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedContinent = continents[indexPath.item]
        let countryVC = CountrySelectionViewController(continent: selectedContinent)
        navigationController?.pushViewController(countryVC, animated: true)
    }
}
