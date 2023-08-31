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
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let visitsVC = VisitsVC()
        visitsVC.tabBarItem = UITabBarItem(title: "Visits", image: UIImage(named: "tabBar1"), tag: 1)
        
        let mapVC = MapVC()
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map.fill"), tag: 2)

        let tabBarList = [homeVC, visitsVC, mapVC]
        viewControllers = tabBarList.map({ UINavigationController(rootViewController: $0) })
//        self.selectedIndex = 1
        self.tabBar.tintColor = AppColor.primaryColor.colorValue()
        self.tabBar.backgroundColor = AppColor.backgroundColor.colorValue()
        
        view.addSubviews()
        setupLayout()
    }
    
    private func setupLayout(){
        
    }
    

}
