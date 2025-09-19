// RootTabBarController.swift
import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = makeTabs()

        setValue(FloatingPlainTabBar(), forKey: "tabBar")

        let ap = UITabBarAppearance()
        ap.configureWithTransparentBackground()
        ap.backgroundEffect = nil
        ap.backgroundColor = .clear
        ap.shadowColor = .clear

        tabBar.standardAppearance = ap
        if #available(iOS 15.0, *) { tabBar.scrollEdgeAppearance = ap }
        
    }


    private func makeTabs() -> [UIViewController] {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let home = mainSB.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        let fav = mainSB.instantiateViewController(withIdentifier: "Favorites") as! FavoritesViewController
        let favNav = UINavigationController(rootViewController: fav)
        favNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        let prof = mainSB.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        let profNav = UINavigationController(rootViewController: prof)
        profNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )

        return [homeNav, favNav, profNav]
    }
}
