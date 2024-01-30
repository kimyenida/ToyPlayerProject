//
//  Presentable.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import UIKit

protocol Presentable {
    var viewController: UIViewController! { get }
    func setRoot(for window: UIWindow)
    func presented(from presentable: Presentable?)
    func registerParent(_ presentable: Presentable & AnyObject)
    func childTransitionCompleted()
}

extension Presentable {
    func setRoot(for window: UIWindow) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        presented(from: window)
    }
    
    func presented(from presentable: Presentable?) {}
    func registerParent(_ presentable: Presentable & AnyObject) {}
    func childTransitionCompleted() {}
}

extension UIViewController: Presentable {}
extension UIView: Presentable {}


extension Presentable {
    func canBeRemovedAsChild() -> Bool {
        guard !(self is UIViewController) else { return true }
        guard let viewController = viewController else { return true }
        return !viewController.isInViewHierarchy
            && viewController.children.allSatisfy { $0.canBeRemovedAsChild() }
    }
}
