import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func createRootNavigationController() -> UINavigationController {
        let continentSelectionVC = ContinentSelectionViewController()
        return UINavigationController(rootViewController: continentSelectionVC)
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createRootNavigationController()
        window?.makeKeyAndVisible()
    }
}
