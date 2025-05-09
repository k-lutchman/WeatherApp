import UIKit

struct UIConstants {
    // Card (WeatherCardView & Country Cards)
    static let cardCornerRadius: CGFloat = 10.0
    static let cardPadding: CGFloat = 10.0
    
    // CollectionView Layout (Continents, countries)
    static let cellItemSize: CGSize = CGSize(width: 150, height: 80)
    static let cellLineSpacing: CGFloat = 20.0
    static let cellInteritemSpacing: CGFloat = 20.0
    static let cellSectionInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // WeatherViewController layout
    static let topPadding: CGFloat = 10.0
    static let stackSpacing: CGFloat = 20.0
    static let stackHorizontalPadding: CGFloat = 20.0
    static let weatherTileHeight: CGFloat = 120.0
}
