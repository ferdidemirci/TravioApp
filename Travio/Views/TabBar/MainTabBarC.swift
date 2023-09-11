//
//  MainTabBarC.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit

class MainTabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .systemBackground
        
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let visitsVC = VisitsVC()
        visitsVC.tabBarItem = UITabBarItem(title: "Visits", image: UIImage(named: "tabBar1"), tag: 1)
        
        let mapVC = MapVC()
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map.fill"), tag: 2)
        
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "tabBar3"), tag: 3)

        let tabBarList = [homeVC, visitsVC, mapVC]
        viewControllers = tabBarList.map({ UINavigationController(rootViewController: $0) })
        viewControllers?.append(settingsVC)
        self.tabBar.tintColor = AppColor.primaryColor.colorValue()
        self.tabBar.backgroundColor = AppColor.backgroundLight.colorValue()
        
        view.addSubviews()
    }
}
