import SwiftUI
import UIKit


// RootTabBarController.swift (geçici test)
final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setValue(FloatingGlassTabBar(), forKey: "tabBar")

        let ap = UITabBarAppearance()
        ap.configureWithTransparentBackground()
        tabBar.standardAppearance = ap
        if #available(iOS 15.0, *) { tabBar.scrollEdgeAppearance = ap }

        // TEST TABS
        func demoVC(_ title: String, _ sys: String) -> UIViewController {
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            vc.title = title
            vc.tabBarItem = UITabBarItem(
                title: title,
                image: UIImage(systemName: sys),
                selectedImage: UIImage(systemName: sys.contains(".") ? sys.replacingOccurrences(of: ".", with: ".") + "" : sys + ".fill")
            )
            return UINavigationController(rootViewController: vc)
        }

        let home = demoVC("Home", "house")                // seçili: "house.fill"
        let fav  = demoVC("Favorites", "heart")           // "heart.fill"
        let prof = demoVC("Profile", "person.circle")     // "person.circle.fill"

        viewControllers = [home, fav, prof]
        print("✅ tabs:", viewControllers?.count ?? 0)
    }
}
