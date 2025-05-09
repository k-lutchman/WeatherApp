import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func createRootNavigationController() -> UINavigationController {
        let continentSelectionVC = ContinentSelectionViewController()
        return UINavigationController(rootViewController: continentSelectionVC)
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createRootNavigationController()
        window?.makeKeyAndVisible()
        return true
    }
}
