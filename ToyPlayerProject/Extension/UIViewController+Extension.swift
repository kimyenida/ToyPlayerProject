//
//  UIViewController+Extension.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import UIKit

extension UIViewController {
    
    var isInViewHierarchy: Bool {
        isBeingPresented
            || presentingViewController != nil
            || presentedViewController != nil
            || parent != nil
            || view.window != nil
            || navigationController != nil
            || tabBarController != nil
            || splitViewController != nil
    }
    
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
    
    func findPresentationContext() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder.definesPresentationContext == true ? nextResponder : nextResponder.findPresentationContext()
        } else {
            return nil
        }
    }
    
}
