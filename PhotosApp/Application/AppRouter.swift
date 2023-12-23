//
//  AppRouter.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

protocol AppRoutable {
    static func createModule() -> UIViewController
}

class AppRouter: AppRoutable {
    
    static func createModule() -> UIViewController {
        let tabbarViewController = UITabBarController()
        tabbarViewController.viewControllers = getTabs()
        return tabbarViewController
    }
    
    private static func getTabs() -> [UIViewController] {
        let photosGridNavigatable = UINavigationController()
        let photosGrid = PhotosGridRouter.createModule()
        
        guard let firstVC = photosGrid as? UIViewController else {
            fatalError("Tabs must be of type UIViewController")
        }
        photosGridNavigatable.viewControllers = [firstVC] // Further tabs such as Albums, etc can be added here

        return [photosGridNavigatable]
    }
}
