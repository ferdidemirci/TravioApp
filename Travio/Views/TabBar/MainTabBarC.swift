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
        visitsVC.tabBarItem = UITabBarItem(title: "Visits", image: UIImage(named: "tabBar.visit"), tag: 1)
        
        let mapVC = MapVC()
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "tabBar.map"), tag: 2)
        
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "tabBar.settings"), tag: 3)

        let tabBarList = [homeVC, visitsVC, mapVC, settingsVC]
        viewControllers = tabBarList.map({ UINavigationController(rootViewController: $0) })
        self.tabBar.tintColor = AppColor.primaryColor.colorValue()
        self.tabBar.backgroundColor = AppColor.tabBarColor.colorValue()
        customizeTabBarAppearance()
    }

    private func customizeTabBarAppearance() {
        tabBar.tintColor = AppColor.primaryColor.colorValue()
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tabBar.insertSubview(blurView, at: 0)

        blurView.alpha = 0.5
        blurView.backgroundColor = .clear

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.gray.cgColor

        tabBar.layer.addSublayer(topBorder)
    }
}
