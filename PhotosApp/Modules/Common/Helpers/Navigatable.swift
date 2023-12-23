//
//  Navigatable.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

protocol Navigatable {
    func present(_ viewControllerToPresent: Navigatable, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension Navigatable where Self: UIViewController {
    func present(_ viewControllerToPresent: Navigatable, animated: Bool, completion: (() -> Void)?) {
        self.present((viewControllerToPresent as! UIViewController), animated: animated, completion: completion)
    }
    
    func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.dismiss(animated: flag, completion: completion)
    }
}
